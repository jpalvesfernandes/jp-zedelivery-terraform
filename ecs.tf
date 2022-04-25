resource "aws_ecs_cluster" "jp-zedelivery-cluster" {
  name = var.cluster-name
}

resource "aws_cloudwatch_log_group" "jp-zedelivery-log-group" {
  name              = "jp-zedelivery-log-group"
  retention_in_days = 1
}

resource "aws_ecs_service" "jp-zedelivery-app-svc" {
  name            = var.app-name
  task_definition = aws_ecs_task_definition.jp-zedelivery-app-task.arn
  cluster         = aws_ecs_cluster.jp-zedelivery-cluster.id
  launch_type     = "FARGATE"
  desired_count   = var.desired-tasks
  deployment_controller {
    type = "CODE_DEPLOY"
  }

  network_configuration {
    security_groups  = [aws_security_group.jp-zedelivery-app-sg.id, aws_security_group.jp-zedelivery-alb-sg.id, aws_security_group.jp-zedelivery-ecs-sg.id]
    subnets          = module.vpc.private_subnets
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.jp-zedelivery-alb-tg-blue.arn
    container_name   = var.container-name
    container_port   = 80
  }

  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }

  depends_on = [aws_lb_target_group.jp-zedelivery-alb-tg-blue, aws_lb_target_group.jp-zedelivery-alb-tg-green]
}

data "template_file" "jp-zedelivery-app-template" {
  template = file("${path.module}/templates/app-task.json")

  vars = {
    image               = "${aws_ecr_repository.jp-zedelivery-app-ecr.repository_url}:latest"
    container_name      = var.container-name
    log-group           = aws_cloudwatch_log_group.jp-zedelivery-log-group.name
    desired-task-cpu    = var.desired-task-cpu
    desired-task-memory = var.desired-task-memory
  }
}

resource "aws_ecs_task_definition" "jp-zedelivery-app-task" {
  family                   = var.app-name
  container_definitions    = data.template_file.jp-zedelivery-app-template.rendered
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.desired-task-cpu
  memory                   = var.desired-task-memory

  execution_role_arn = aws_iam_role.jp-zedelivery-ecs-execution-role.arn
  task_role_arn      = aws_iam_role.jp-zedelivery-ecs-execution-role.arn
}