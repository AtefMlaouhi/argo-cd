# Terraform

- [Terraform](#terraform)
  - [Prerequis](#prerequis)
  - [Gestion de l'état Terraform](#gestion-de-létat-terraform)
  - [Gestion des données sensibles](#gestion-des-données-sensibles)
  - [Gitlab](#gitlab)
    - [Importer un projet gitlab](#importer-un-projet-gitlab)
  - [ArgoCD](#argocd)
    - [Configuration](#configuration)
    - [Ajouter un nouveau repository/application](#ajouter-un-nouveau-repositoryapplication)
    - [Importer un repository/application existante](#importer-un-repositoryapplication-existante)
  - [Kafka](#kafka)
    - [Configurer la CI/CD Terraform](#configurer-la-cicd-terraform)
    - [Gérer des topics kafka](#gérer-des-topics-kafka)

## Prerequis

Pour éviter d'installer tout le tooling, une image docker est disponible pour être utilisée en tant que devcontainer :
* Avoir WSL2 installé ([doc](https://docs.microsoft.com/fr-fr/windows/wsl/install))
* Avoir vscode installé
* Avoir l'extension `Remote - Containers` installée
* Etre connecté au registry docker (`docker login registry-git.harvest.fr`)
* Ouvrir le répertoire ce répertoire dans vscode & ouvrir le répertoire dans le container (par la notif qui devrait apparaitre)

## Gestion de l'état Terraform

Terraform a besoin de stocker son état (state) pour pouvoir faire les comparaisons lors des modifications à venir. Une manière simple de le gérer est d'utiliser Gitlab (https://docs.gitlab.com/ee/user/infrastructure/iac/terraform_state.html).

Le devcontainer contient des scripts pour faciliter l'intégration/configuration des données sensibles. [direnv](https://direnv.net/) permet de charger dynamiquement des fichiers .envrc & d'exécuter des scripts en fonction du répertoire dans lequel vous êtes.

Saisir les variables dans le fichier `.envrc`
```shell
export GITLAB_USERNAME=       # Votre id gitlab (ex: vdeoliveira)
export GITLAB_TOKEN=          # Un Personal Access Tokens avec le scope `api`
export PROJECT_ID=            # L'ID du projet gitlab dans lequel l'état sera sauvegarder
```
Le PROJECT_ID servira a définir dans quel projet sera stocké le fichier d'état de Terraform (dans la section Infrastructure/Terraform du projet, ex: https://git.harvest.fr/O2S/o2s-modularisation/templates/terraform-argocd-gitlab/-/terraform)

Le ``PROJECT_ID`` peut être commit dans git mais attention à ne pas commit l'username/token.

## Gestion des données sensibles

Les valeurs des variables terraform peuvent être soumisent à terraform de plusieurs manières, exemple pour la variable suivante :
```javascript
variable "mon_token" {
  type      = string
  sensitive = true  // Penser à bien spécifier que la variable est sensible pour que sa valeur soit masquée dans les consoles
}
```

* en variable d'environnement : TF_VAR_mon_token (par ``export`` dans le shell ou par le ``.envrc``, à combiner avec un vault/keepass en cli pour plus de sécurité)
```shell
# exemple ici avec https://www.passwordstore.org/
export TF_VAR_mon_token=$(pass harvest/gitlab/pat_terraform_token)
```
* en fichier ``.tfvars`` lors du plan/apply : `terraform plan -var-file=my_securefile.tfvars`
```hcl
mon_token = "montoken"
```


## Gitlab

Piloter Gitlab avec Terraform :
* créer/configurer des projets
* créer des access/deploy token
* configurer des webhook/badges
* etc

### Importer un projet gitlab
- noter son id
- copier un bloc terraform projet (exemple dans le fichier example_gitlab_project.tf)
```hcl
module "gitlab-project-geocoding" {
  source = "./modules/project-app"

  project_name = "fr.harvest.geocoding"                              # Project name
  project_path = "O2S/o2s-modularisation/fr.harvest.geocoding"       # Full project slug (without git.harvest.fr)
  argocd_hosts = local.argocd_all_hosts
}
```
- executer les commandes suivantes dans le répertoire ``src/gitlab``

```javascript
// Autorise l'utilisation du fichier .envrc; à exécuter également lors de l'ajout de nouveaux modules/provider
direnv allow
```

```javascript
// import le projet gitlab dans le state terraform
terraform import module.projet-geocoding.gitlab_project.project <PROJECT_ID>
```

```javascript
// import la protection de la branche `main` dans le state terraform
terraform import module.projet-geocoding.gitlab_branch_protection.main <PROJECT_ID>:main  
```
où `projet-geocoding` au nom du module terraform que vous venez d'ajouter

```javascript
terraform plan // Relecture des modifications en attente
```

```javascript
terraform apply // Relecture des modifications en attente puis application après confirmation
```

## ArgoCD

### Configuration

Le provider terraform ArgoCD se sert l'authentification ambiante pour utiliser l'api. On doit donc se connecter aux environnements ArgoCD que l'on souhaite utiliser au préalable.

```shell
# Clusters internes
argocd login argocd-k8s.dev.harvest.fr --sso --grpc-web
argocd login argocd-k8s.preprod.harvest.fr --sso --grpc-web
argocd login argocd.harvest.fr --sso --grpc-web

# Cluster flex
argocd login argocd.flex-dev.harvest.fr --sso --grpc-web
#argocd login argocd.flex-preprod.harvest.fr --sso --grpc-web
argocd login argocd-tooling-flex.harvest.fr --sso --grpc-web
argocd login argocd-flex.harvest.fr --sso --grpc-web --skip-test-tls
```

### Ajouter un nouveau repository/application

* copier un bloc terraform argocd
```hcl
module "argocd-application-geocoding-api" {
  source = "../../modules/argocd-project-app"

  project = {
    name = "o2sm" # project name in ArgoCD
  }
  namespace = "geocoding" # Namespace in which applications will be deployed (suffixed by env.name, ex: geocoding-dev)
  app = {
    name = "geocoding-api"                   # Name of the applications that will be created in ArgoCD (suffixed by env.name)
    path = "deploy/fr.harvest.geocoding-api" # Path to the helm package within the repository
  }
  env = {
    # Each element of the envs array will make an ArgoCD application
    envs = [
      {
        name = "dev"
        parameters = [
          { name = "global.rancherCluster", value = var.rancher_clusterids.dev },
          { name = "global.rancherProject", value = var.rancher_projects.o2sm.dev }
        ]
      },
      {
        name = "rci"
        parameters = [
          { name = "global.rancherCluster", value = var.rancher_clusterids.dev },
          { name = "global.rancherProject", value = var.rancher_projects.o2sm.dev }
        ]
      }
    ]
    # use_env_naming   = false    # Whatever to suffix app.name, namespace.name with env name (will also add a values-{env}.yaml)
  }
  repository = {
    create   = true
    url      = "https://git.harvest.fr/O2S/o2s-modularisation/fr.harvest.geocoding.git" # If the repository already exists in ArgoCD, you can omit create/username/password fields
    username = module.gitlab-project-geocoding.read_token.login
    password = module.gitlab-project-geocoding.read_token.value
  }

  providers = {
    argocd.project = argocd.dev
    argocd.app     = argocd.dev
  }
}

```

```javascript
// Autorise l'utilisation du fichier .envrc; à exécuter également lors de l'ajout de nouveaux modules/provider
direnv allow // Configure le module que nous venons de copier
```

```javascript
terraform plan // Relecture des modifications en attente
```

```javascript
terraform apply // Relecture des modifications en attente puis application après confirmation
```

### Importer un repository/application existante

* Copier le bloc terraform argocd comme si vous vouliez en créer un nouveau

```javascript
// Autorise l'utilisation du fichier .envrc; à exécuter également lors de l'ajout de nouveaux modules/provider
direnv allow // Configure le module que nous venons de copier
```

```javascript
terraform plan // Relecture des modifications en attente
```
* Noter les ids des ressources que terraform veut créer, exemple :

```hcl
  # module.argocd-application-geocoding-api.argocd_application.application["dev"] will be created
  + resource "argocd_application" "application" {
      + cascade = true
      + id      = (known after apply)
      + wait    = false

      + metadata {
          + annotations      = {
              + "argocd.argoproj.io/manifest-generate-paths" = "deploy/fr.harvest.geocoding-api"
            }
          + generation       = (known after apply)
          + name             = "geocoding-api-dev"
          + namespace        = "argocd"
          + resource_version = (known after apply)
          + uid              = (known after apply)
        }
        ...
```
Ici l'id est `module.argocd-application-geocoding-api.argocd_application.application["dev"]`, som nom est `geocoding-api-dev` et la ressource est de type `argocd_application`
* On se rend sur la page https://registry.terraform.io/providers/oboukili/argocd/latest/docs
* On cherche la ressource correspondante, ici `argocd_application`
* On cherche la section `import` (ex: https://registry.terraform.io/providers/oboukili/argocd/latest/docs/resources/application#import)
* Dans notre cas, la commande d'import sera donc :
```shell
terraform import 'module.argocd-application-geocoding-api.argocd_application.application["dev"]' geocoding-api-dev
```
* Refaire un `terraform plan`
* Soit il n'y a pas de différences entre la version terraform et la version ArgoCD, soit il y a quelques différences et celles-ci apparaitront dans le diff
* Refaire les mêmes manip avec les autres ressources à importer

## Kafka

### Configurer la CI/CD Terraform

Pour la CI/CD, nous allons utiliser [Atlantis](https://www.runatlantis.io/).
Doc O2SM modularisation : https://confluence.harvest.fr/pages/viewpage.action?pageId=85927971#CI/CD-CIKafka

Dans `src/gitlab/terraform.tfvars`, remplir la variable `project_terraform` avec le projet gitlab contenant ce projet terraform

```javascript
// exemple pour https://git.harvest.fr/O2S/o2s-modularisation/argocd-o2sm
project_terraform = {
  name = "argocd-o2sm"
  path = "O2S/o2s-modularisation/argocd-o2sm"
}
```

```javascript
cd src/gitlab
direnv allow  // Autorise l'utilisation du fichier .envrc
```

Gitlab définit des protections par défaut sur la branche `main/master`, si on importe le projet il faut également importer la protection existante pour pouvoir la mettre à jour.

```javascript
terraform import module.terraform_project.gitlab_project.project <PROJECT_ID>
terraform import module.terraform_project.gitlab_branch_protection.main <PROJECT_ID>:main
terraform apply
```

### Gérer des topics kafka

Vu qu'il n'y a pas d'authentification nécessaire (pour l'instant) pour accéder à Kafka, il n'y a pas de configuration à faire. Les urls sont déjà définies dans les providers dans https://git.harvest.fr/O2S/o2s-modularisation/templates/terraform-argocd-gitlab/-/blob/main/src/kafka/main.tf#L6-34 et https://git.harvest.fr/O2S/o2s-modularisation/templates/terraform-argocd-gitlab/-/blob/main/src/kafka/variables.tf#L18-32

Dans `src/kafka/env_dev.tf` (ou le fichier d'environnement concerné par vos topics), modifier les topics que vous souhaitez, puis :

```javascript
cd src/kafka
direnv allow  // Autorise l'utilisation du fichier .envrc
terraforma apply
```
