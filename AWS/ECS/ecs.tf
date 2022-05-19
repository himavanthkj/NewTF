data "template_file" "template_file_hima" {
  template = file("./templates/hima.json.tpl")
  vars = {
    docker_registry       = var.docker_registry
    app_name              = var.app_name
    app_image             = var.app_image
    tag                   = var.tag
    environment           = var.environment
    app_family            = var.app_family
    app_port              = var.container_port
    host_port             = var.fargate_port
    fargate_cpu           = var.fargate_cpu
    fargate_memory        = var.fargate_memory
    awslogs_group         = var.awslogs_group
    awslogs_stream_prefix = var.environment
    ssm_arn = var.ssm_arn
  }
}
module "ecs-fargate" {
  #source = "git::ssh://git@himavanth.git"
  source = "cn-terraform/ecs-fargate/aws"
  cloudwatch_loggroup_name = var.app_name
  container_definitions = data.template_file.template_file_hima.rendered
  deployment_minimum_healthy_percent = 50
  desired_count = var.replica_count
  ecs_cluster_arn = var.ecs_cluster
  ecs_service_name = var.app_name
  family = var.app_name
  fargate_cpu = var.fargate_cpu
  fargate_memory = var.fargate_memory
  service_security_group_id = [data.aws_security_group.default.id]
  service_subnets_id = data.aws_subnet_ids.default.ids
  task_execution_role_arn = data.aws_iam_role.ecs_task_execution_role.arn
  task_role_arn = data.aws_iam_role.ecs_task_role.arn
  platform_version = "1.4.0"
  service_discovery_name = var.service_discovery_name
  service_discovery_namespace_id = data.terraform_remote_state.ecs.outputs.aws_service_discovery_namespace_understand_dev
  }
