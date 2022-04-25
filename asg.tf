resource "aws_appautoscaling_target" "jp-zedelivery-app-scale" {
  service_namespace  = "ecs"
  resource_id        = "service/${aws_ecs_cluster.jp-zedelivery-cluster.name}/${aws_ecs_service.jp-zedelivery-app-svc.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  max_capacity = var.max-tasks
  min_capacity = var.min-tasks
}

resource "aws_cloudwatch_metric_alarm" "cpu-utilization-high" {
  alarm_name          = "jp-zedelivery-CPU-Utilization-High"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.cpu-scale-up

  dimensions = {
    ClusterName = aws_ecs_cluster.jp-zedelivery-cluster.name
    ServiceName = aws_ecs_service.jp-zedelivery-app-svc.name
  }

  alarm_actions = [aws_appautoscaling_policy.app-up.arn]
}

resource "aws_appautoscaling_policy" "app-up" {
  name               = "jp-zedelivery-app-scale-up"
  service_namespace  = aws_appautoscaling_target.jp-zedelivery-app-scale.service_namespace
  resource_id        = aws_appautoscaling_target.jp-zedelivery-app-scale.resource_id
  scalable_dimension = aws_appautoscaling_target.jp-zedelivery-app-scale.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu-utilization-low" {
  alarm_name          = "jp-zedelivery-CPU-Utilization-Low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.cpu-scale-down

  dimensions = {
    ClusterName = aws_ecs_cluster.jp-zedelivery-cluster.name
    ServiceName = aws_ecs_service.jp-zedelivery-app-svc.name
  }

  alarm_actions = [aws_appautoscaling_policy.app-down.arn]
}

resource "aws_appautoscaling_policy" "app-down" {
  name               = "jp-zedelivery-scale-down"
  service_namespace  = aws_appautoscaling_target.jp-zedelivery-app-scale.service_namespace
  resource_id        = aws_appautoscaling_target.jp-zedelivery-app-scale.resource_id
  scalable_dimension = aws_appautoscaling_target.jp-zedelivery-app-scale.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}