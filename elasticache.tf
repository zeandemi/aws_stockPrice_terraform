resource "aws_elasticache_replication_group" "redis" {
    description = "Secured Redis"
    replication_group_id = "secured-redis"
    node_type = "cache.t3.micro"
    num_cache_clusters = 2
    automatic_failover_enabled = true
    multi_az_enabled = true
    engine_version = "7.0"
    parameter_group_name = "default.redis7"
    port = 6379
    security_group_ids = [aws_security_group.redis_sg.id]
   # for_each = {
   #     for k,v in aws_elasticache_subnet_group.redis_subnetGroup :
   #     k => v
   # }
    #subnet_group_name = each.value.name
    subnet_group_name = aws_elasticache_subnet_group.redis_subnetGroup.name

    #Security festures
    transit_encryption_enabled = true
    at_rest_encryption_enabled = true


    tags = {
        Name = "Secured Redis Cluster"
    }
  
}