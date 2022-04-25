region = "us-east-1"

cluster-name = "ze"

app-name = "breja"

container-name = "breja"

desired-tasks = 2

min-tasks = 2

max-tasks = 4

cpu-scale-up = 80

cpu-scale-down = 30

desired-task-cpu = "256"

desired-task-memory = "512"

deployment-configuration = "CodeDeployDefault.ECSCanary10Percent5Minutes"