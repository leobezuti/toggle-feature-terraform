output "applied_manifests" {
  description = "List of all manifest file paths applied by the module."
  value = concat(
    keys(kubernetes_manifest.namespaces),
    keys(kubernetes_manifest.manifests)
  )
}
