# Contributing

## Introduction

Le devcontainer est consituté de 2 images :
* .devcontainer/base/.devcontainer/Dockerfile qui défini les bases
* .devcontainer/Dockerfile qui installe des features par dessus

## Construire l'image de base

* Apportez vos modifications dans .devcontainer/base/.devcontainer/Dockerfile
* Ouvrez le fichier .devcontainer/base/.devcontainer/devcontainer.json
* Testez votre nouvelle image localement
* Lorsque vous êtes satisfait des résultats, exécutez la commande suivante (n’oubliez pas de mettre à jour/remplacer {TAG}):
```shell
npx @devcontainers/cli build --workspace-folder .devcontainer/base --image-name registry-git.harvest.fr/o2s/o2s-modularisation/templates/terraform-argocd-gitlab/devcontainer:{TAG}

docker push registry-git.harvest.fr/o2s/o2s-modularisation/templates/terraform-argocd-gitlab/devcontainer:{TAG}
```

## Prebuild the Docker image

* Apportez vos modifications dans .devcontainer//Dockerfile
* Ouvrez le fichier .devcontainer//devcontainer.json
* Commenter la propriété `image` (Line 5) et dé-commenter la propriété `build` (Line 7 -> 13)
* Si besoin, changer la version de l'image de base `build.arg.VERSION`
* Testez votre nouvelle image localement
* Lorsque vous êtes satisfait des résultats, exécutez la commande suivante (n’oubliez pas de mettre à jour/remplacer {TAG}):
```shell
npx @devcontainers/cli build --workspace-folder . --image-name registry-git.harvest.fr/o2s/o2s-modularisation/templates/terraform-argocd-gitlab/devcontainer-prebuilt:{TAG}

docker push registry-git.harvest.fr/o2s/o2s-modularisation/templates/terraform-argocd-gitlab/devcontainer-prebuilt:{TAG}
```
