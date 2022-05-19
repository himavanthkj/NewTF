# cloudwatch loggroup
resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name = "/ecs/${var.cloudwatch_loggroup_name}"
  retention_in_days = var.retention_in_days
  tags = var.add_tags
}

#ecs task_definition
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = var.family
  network_mode             = "awsvpc"
  execution_role_arn       = var.task_execution_role_arn
  task_role_arn            = var.task_role_arn
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  requires_compatibilities = ["FARGATE"]
  container_definitions    = var.container_definitions
  depends_on = [aws_cloudwatch_log_group.cloudwatch_log_group]
  tags = var.add_tags
}

#ecs service with alb
resource "aws_ecs_service" "ecs_service_with_alb" {
  count           = var.alb_container_name != "" ? 1 : 0
  name            = var.ecs_service_name
  cluster         = var.ecs_cluster_arn
  task_definition = local.task_definition_arn
  desired_count   = var.desired_count
  health_check_grace_period_seconds = var.health_check_grace_period
  platform_version = var.platform_version
  launch_type     = "FARGATE"
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  propagate_tags = "SERVICE"

  network_configuration {
    security_groups  = var.service_security_group_id
    subnets          = var.service_subnets_id
    assign_public_ip = var.assign_public_ip
  }
  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = var.alb_container_name
    container_port   = var.alb_container_port
  }
  depends_on = [aws_ecs_task_definition.ecs_task_definition]
  tags = var.add_tags
}


#ecs service discovery(optional)
resource "aws_service_discovery_service" "ecs_internal_service_discovery_service" {
  count = var.service_discovery_name != "" ? 1 : 0
  name = var.service_discovery_name
  dns_config {
    namespace_id = var.service_discovery_namespace_id

    dns_records {
      ttl  = 10
      type = "A"
    }
  }
  health_check_custom_config {
    failure_threshold = 5
  }
  tags = var.add_tags
}



#ecs service with service discovery without alb
resource "aws_ecs_service" "ecs_service_with_service_discovery" {
  count = var.service_discovery_namespace_id != "" ? 1 : 0
  name            = var.ecs_service_name
  cluster         = var.ecs_cluster_arn
  task_definition = local.task_definition_arn
  desired_count   = var.desired_count
  platform_version = var.platform_version
  launch_type     = "FARGATE"
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  propagate_tags = "SERVICE"

  network_configuration {
    security_groups  = var.service_security_group_id
    subnets          = var.service_subnets_id
    assign_public_ip = var.assign_public_ip
  }

  service_registries {
    registry_arn = local.service_discovery_registry_arn
  }
  tags = var.add_tags
  depends_on = [aws_service_discovery_service.ecs_internal_service_discovery_service]
}
