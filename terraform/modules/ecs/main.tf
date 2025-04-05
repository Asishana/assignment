resource "aws_ecs_cluster" "main" {
  name = "ecs-cluster"
}

resource "aws_ecs_task_definition" "api_task" {
  family                   = "api-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "api-container"
      image     = "oseghale1/flask-app"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
          protocol      = "tcp"
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "api_service" {
  name            = "api-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.api_task.arn

  network_configuration {
    subnets         = var.public_subnets
    security_groups = var.security_groups
    assign_public_ip = true 

  }
  

  desired_count          = 1
  launch_type            = "FARGATE"
  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = "api-container"
    container_port   = 5000
  }
}