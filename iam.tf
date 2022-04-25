resource "aws_iam_role" "jp-zedelivery-ecs-execution-role" {
  name               = "jp-zedelivery-ecs-task-role"
  assume_role_policy = file("${path.module}/policies/ecs-task-execution-role.json")
}

resource "aws_iam_role_policy" "jp-zedelivery-ecs-execution-role-policy" {
  name   = "jp-zedelivery-role-policy"
  policy = file("${path.module}/policies/ecs-execution-role-policy.json")
  role   = aws_iam_role.jp-zedelivery-ecs-execution-role.id
}

resource "aws_iam_role" "jp-zedelivery-codepipeline-role" {
  name               = "jp-zedelivery-codepipeline-role"
  assume_role_policy = file("${path.module}/policies/codepipeline_role.json")
}

data "template_file" "jp-zedelivery-codepipeline-policy" {
  template = file("${path.module}/policies/codepipeline.json")

  vars = {
    aws_s3_bucket_arn = aws_s3_bucket.jp-zedelivery-source.arn
  }
}

resource "aws_iam_role_policy" "jp-zedelivery-codepipeline-policy" {
  name   = "jp-zedelivery-codepipeline-policy"
  role   = aws_iam_role.jp-zedelivery-codepipeline-role.id
  policy = data.template_file.jp-zedelivery-codepipeline-policy.rendered
}

resource "aws_iam_role" "jp-zedelivery-codebuild-role" {
  name               = "jp-zedelivery-codebuild-role"
  assume_role_policy = file("${path.module}/policies/codebuild_role.json")
}

data "template_file" "jp-zedelivery-codebuild-policy" {
  template = file("${path.module}/policies/codebuild_policy.json")

  vars = {
    aws_s3_bucket_arn = aws_s3_bucket.jp-zedelivery-source.arn
  }
}

resource "aws_iam_role_policy" "jp-zedelivery-codebuild-policy" {
  name   = "jp-zedelivery-codebuild-policy"
  role   = aws_iam_role.jp-zedelivery-codebuild-role.id
  policy = data.template_file.jp-zedelivery-codebuild-policy.rendered
}

resource "aws_iam_role" "jp-zedelivery-codedeploy-role" {
  name               = "jp-zedelivery-codedeploy-role"
  assume_role_policy = file("${path.module}/policies/codedeploy_role.json")
}

resource "aws_iam_role_policy" "jp-zedelivery-codedeploy-policy" {
  name   = "jp-zedelivery-codedeploy-policy"
  role   = aws_iam_role.jp-zedelivery-codedeploy-role.id
  policy = file("${path.module}/policies/codedeploy.json")
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.jp-zedelivery-codedeploy-role.name
}