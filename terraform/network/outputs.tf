output "vpc_id" {
    value = aws_vpc.main.id
}

output "subnet_ids" {
    value = {
        # Public Tier 
        public_az1 = aws_subnet.public["public_a"].id
        public_az2 = aws_subnet.public["public_b"].id

        # Web Tier
        web_az1 = aws_subnet.private["web_a"].id
        web_az2 = aws_subnet.private["web_b"].id

        # App Tier
        app_az1 = aws_subnet.private["app_a"].id
        app_az2 = aws_subnet.private["app_b"].id

        # DB Tier
        db_az1 = aws_subnet.db["db_a"].id
        db_az2 = aws_subnet.db["db_b"].id
    }
}
