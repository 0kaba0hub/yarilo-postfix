{{/*
Mail domains: mail.domain + extraDomains (if set).
*/}}
{{- define "yarilo-postfix.mailDomains" -}}
{{- if .Values.mail.extraDomains -}}
{{ .Values.mail.domain }} {{ .Values.mail.extraDomains }}
{{- else -}}
{{ .Values.mail.domain }}
{{- end -}}
{{- end -}}

{{/*
MySQL env vars from secret.
*/}}
{{- define "yarilo-postfix.mysqlEnv" -}}
{{- if .mysql.secretName }}
- name: MYSQL_HOST
  valueFrom:
    secretKeyRef:
      name: {{ .mysql.secretName }}
      key: MYSQL_HOST
- name: MYSQL_USER
  valueFrom:
    secretKeyRef:
      name: {{ .mysql.secretName }}
      key: MYSQL_USER
- name: MYSQL_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .mysql.secretName }}
      key: MYSQL_PASSWORD
- name: MYSQL_DBNAME
  valueFrom:
    secretKeyRef:
      name: {{ .mysql.secretName }}
      key: MYSQL_DBNAME
{{- end }}
{{- end -}}

{{/*
TLS volume mount — no-op when secretName is empty.
*/}}
{{- define "yarilo-postfix.tlsMount" -}}
{{- if . -}}
- name: tls
  mountPath: /etc/postfix/tls
  readOnly: true
{{- end -}}
{{- end -}}

{{/*
TLS volume — no-op when secretName is empty.
*/}}
{{- define "yarilo-postfix.tlsVolume" -}}
{{- if . -}}
- name: tls
  secret:
    secretName: {{ . }}
    defaultMode: 0440
{{- end -}}
{{- end -}}

{{/*
DKIM volume mount — no-op when secretName is empty.
*/}}
{{- define "yarilo-postfix.dkimMount" -}}
{{- if . -}}
- name: dkim
  mountPath: /etc/rspamd/dkim
  readOnly: true
{{- end -}}
{{- end -}}

{{/*
DKIM volume — no-op when secretName is empty.
*/}}
{{- define "yarilo-postfix.dkimVolume" -}}
{{- if . -}}
- name: dkim
  secret:
    secretName: {{ . }}
    defaultMode: 0440
{{- end -}}
{{- end -}}
