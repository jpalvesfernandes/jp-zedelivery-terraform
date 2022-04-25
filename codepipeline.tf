resource "aws_s3_bucket" "jp-zedelivery-source" {
  bucket        = "jp-zedelivery-source"
  force_destroy = true
}

resource "aws_codepipeline" "jp-zedelivery-pipeline" {
  name     = "jp-zedelivery-pipeline"
  role_arn = aws_iam_role.jp-zedelivery-codepipeline-role.arn

  artifact_store {
    location = aws_s3_bucket.jp-zedelivery-source.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        OAuthToken = var.github_token
        Owner      = var.git_repository_owner
        Repo       = var.git_repository_name
        Branch     = var.git_repository_branch
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["SourceArtifact"]
      output_artifacts = [
        "ImageArtifact",
        "DefinitionArtifact"
      ]

      configuration = {
        ProjectName = aws_codebuild_project.jp-zedelivery-build.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name      = "Deploy"
      category  = "Deploy"
      owner     = "AWS"
      provider  = "CodeDeployToECS"
      version   = "1"
      run_order = 1
      input_artifacts = [
        "ImageArtifact",
        "DefinitionArtifact",
      ]
      configuration = {
        ApplicationName                = aws_codedeploy_app.jp-zedelivery-deploy.name
        DeploymentGroupName            = aws_codedeploy_deployment_group.jp-zedelivery-deploy-group.deployment_group_name
        TaskDefinitionTemplateArtifact = "DefinitionArtifact"
        TaskDefinitionTemplatePath     = "taskdef.json"
        AppSpecTemplateArtifact        = "DefinitionArtifact"
        AppSpecTemplatePath            = "appspec.yaml"
        Image1ArtifactName             = "ImageArtifact"
        Image1ContainerName            = "IMAGE1_NAME"
      }
    }
  }
}
