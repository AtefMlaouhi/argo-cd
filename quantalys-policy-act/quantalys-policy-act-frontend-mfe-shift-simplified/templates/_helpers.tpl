{{/*
Expand the name of the chart.
*/}}
{{- define "quantalys.policy.act.frontend.mfe.shift.simplified.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "quantalys.policy.act.frontend.mfe.shift.simplified.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "quantalys.policy.act.frontend.mfe.shift.simplified.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "quantalys.policy.act.frontend.mfe.shift.simplified.labels" -}}
helm.sh/chart: {{ include "quantalys.policy.act.frontend.mfe.shift.simplified.chart" . }}
{{ include "quantalys.policy.act.frontend.mfe.shift.simplified.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "quantalys.policy.act.frontend.mfe.shift.simplified.selectorLabels" -}}
app.kubernetes.io/name: {{ include "quantalys.policy.act.frontend.mfe.shift.simplified.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "quantalys.policy.act.frontend.mfe.shift.simplified.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "quantalys.policy.act.frontend.mfe.shift.simplified.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
