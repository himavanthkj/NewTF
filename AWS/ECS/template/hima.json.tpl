[
  {
    "name": "${app_name}",
    "image": "${docker_registry}/${app_image}:${tag}",
    "essential": true,
     "logConfiguration": {
         "logDriver": "awslogs",
      "options": {
        "awslogs-region": "us-east-1",
        "awslogs-stream-prefix": "${awslogs_stream_prefix}",
        "awslogs-group": "/ecs/${app_name}"
      }
    },
    "portMappings": [
      {
        "containerPort": ${app_port},
        "hostPort": ${host_port},
        "protocol": "tcp"
      }
    ],
    "cpu": ${fargate_cpu},
    "environment": [
      {
        "name": "APP_ENV",
        "value": "${environment}"
      }
    ],
    "ulimits": [
      {
        "name": "nofile",
        "softLimit": 65536,
        "hardLimit": 65536
      }
    ],
    "mountPoints": [],
    "memory": ${fargate_memory},
    "volumesFrom": []
  }
]
