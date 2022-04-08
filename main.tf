provider "google" {
  project = "fabled-citadel-342513"
  region = "asia-southeast2"
  zone = "asia-southeast2-a"
}

# Deploy image to Cloud Run
resource "google_cloud_run_service" "my_web_app" {
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
data "google_iam_policy" "no_auth" {
  binding {
    members = [
      "allUsers",
    ]
    role    = "roles/run.invoker"
  }
}

# Enable public access on Cloud Run service
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