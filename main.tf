# Semacem import untuk nunjukin kita ngambil resource dari mana
# dalam case ini kita import gogole, karna kita butuh resource google
provider "google" {
  project = "fabled-citadel-342513"
  region = "asia-southeast2"
  zone = "asia-southeast2-a"
}

# Deploy image to Cloud Run
# ngebuat resource di gcp dengan template/tipe resource google_cloud_run_service
resource "google_cloud_run_service" "my_web_app" {
  # field nama resourcenya
  name = "my-web-app"
  location = "asia-southeast2"
  template {
    spec {
      containers {
        image = "asia.gcr.io/fabled-citadel-342513/learn-go-echo"
        ports {
          container_port = 1111
        }
      }
    }
  }
  traffic {
    percent = 100
    latest_revision = true
  }
}

# Create public access
# lu mau bikin sebuah iam policy data biar bisa dipake datanya ditempat lain, kek factory pattern
# tapi ini intinya u mau dapetin sebuah data dati template ini, terus u kirimin bbrp parameter yang dibutuhin, terus hasilnya u pake ditempat lain
data "google_iam_policy" "no_auth" {
  binding {
    members = [
      "allUsers",
    ]
    role    = "roles/run.invoker"
  }
}

# Enable public access on Cloud Run service
# buat kasih cloud run gw, siapa aja yang boleh cloud run gw, dengan cara ngetaro policy_data yang dah didapet
resource "google_cloud_run_service_iam_policy" "no_auth" {
  location = google_cloud_run_service.my_web_app.location
  project = google_cloud_run_service.my_web_app.project
  service = google_cloud_run_service.my_web_app.name
  policy_data = data.google_iam_policy.no_auth.policy_data
}

# Return service URL
output "url" {
  value = google_cloud_run_service.my_web_app.status[0].url
}