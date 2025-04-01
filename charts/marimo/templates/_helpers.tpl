{{/*
Generate the full name of the release
*/}}
{{- define "marimo.fullname" -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Generate the name of the chart
*/}}
{{- define "marimo.name" -}}
{{- .Chart.Name -}}
{{- end }}

{{/*
Generate the chart version
*/}}
{{- define "marimo.chart" -}}
{{ .Chart.Name }}-{{ .Chart.Version }}
{{- end }}
