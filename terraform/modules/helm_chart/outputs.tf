output "release" {
  value = random_pet.release[0].id
}

output "revision" {
  value = helm_release.release.revision
}