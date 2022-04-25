data "template_file" "buildspec" {
  template = file("${path.module}/templates/buildspec.yml")

  vars = {
    repository_url     = aws_ecr_repository.jp-zedelivery-app-ecr.repository_url
    region             = var.region
    cluster_name       = var.cluster-name
    container_name     = var.container-name
    task_execution_arn = aws_iam_role.jp-zedelivery-ecs-execution-role.arn
  }
}

resource "aws_codebuild_project" "jp-zedelivery-build" {
  name          = "jp-zedelivery-build"
  build_timeout = "60"

  service_role = aws_iam_role.jp-zedelivery-codebuild-role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/docker:17.09.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = data.template_file.buildspec.rendered
  }
}
