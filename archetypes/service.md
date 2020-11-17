---
{{ $service := (index $.Site.Data.oniontree.unsorted .Name) -}}
{{- $news := dict -}}
{{- if $.Site.Data.news -}}
    {{- $news = (index $.Site.Data.news .Name) -}}
{{- end -}}
{{- $alerts := dict -}}
{{- if $.Site.Data.alerts -}}
    {{- $alerts = (index $.Site.Data.alerts .Name) -}}
{{- end -}}
{{- $tags := slice -}}
{{- range $tag, $services := $.Site.Data.oniontree.tagged -}}
    {{- range $name, $content := $services -}}
        {{- if eq $name $.Name }}
            {{- $tags = $tags | append $tag -}}
        {{- end }}
    {{- end -}}
{{- end -}}
{{- $communities := dict -}}
{{- range $id, $community := $.Site.Data.communities -}}
    {{- if index $community $.Name -}}
        {{- $communities = merge $communities (dict $id (index $community $.Name)) -}}
    {{- end -}}
{{- end -}}
{{ dict "id" .Name | transform.Remarshal "yaml" -}}
{{ dict "title" (index $service "name") | transform.Remarshal "yaml" -}}
{{ dict "description" (index $service "description" | default "") | transform.Remarshal "yaml" -}}
date: {{ .Date }}
{{ dict "urls" (index $service "urls" | default slice) | transform.Remarshal "yaml" -}}
{{ dict "public_keys" (index $service "public_keys" | default slice) | transform.Remarshal "yaml" -}}
{{ dict "communities" ($communities | default dict) | transform.Remarshal "yaml" -}}
{{ dict "tags" ($tags | default slice) | transform.Remarshal "yaml" -}}
---
