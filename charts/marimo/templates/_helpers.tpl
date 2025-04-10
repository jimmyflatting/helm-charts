{{/*
Expand the name of the chart.
*/}}
{{- define "marimo.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "marimo.fullname" -}}
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
{{- define "marimo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "marimo.labels" -}}
helm.sh/chart: {{ include "marimo.chart" . }}
{{ include "marimo.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "marimo.selectorLabels" -}}
app.kubernetes.io/name: {{ include "marimo.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "marimo.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "marimo.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the token secret
*/}}
{{- define "library-chart.secretNameToken" -}}
{{- printf "%s-secrettoken" (include "library-chart.fullname" .) }}
{{- end }}

{{/*
Get a value from a dictionary with default if it doesn't exist
*/}}
{{- define "marimo.getSafeValue" -}}
{{- $root := index . 0 -}}
{{- $key := index . 1 -}}
{{- $default := index . 2 -}}
{{- if hasKey $root $key -}}
{{- index $root $key -}}
{{- else -}}
{{- $default -}}
{{- end -}}
{{- end -}}

{{/*
Get a nested value safely, with default
*/}}
{{- define "marimo.getSafeNestedValue" -}}
{{- $obj := index . 0 -}}
{{- $path := index . 1 -}}
{{- $default := index . 2 -}}
{{- $current := $obj -}}
{{- range $segment := splitList "." $path -}}
  {{- if hasKey $current $segment -}}
    {{- $current = index $current $segment -}}
  {{- else -}}
    {{- $current = $default -}}
    {{- break -}}
  {{- end -}}
{{- end -}}
{{- $current -}}
{{- end -}}
