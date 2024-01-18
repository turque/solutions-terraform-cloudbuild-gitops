# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "~> 9.0"

    project_id   = "${var.project}"
    network_name = "${var.env}-vpc"
    routing_mode = "GLOBAL"

    subnets = [
        {
            subnet_name           = "${var.env}-subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = "us-west1"
            description           = "subnet for frontends services"
        },
        {
            subnet_name           = "${var.env}-subnet-02"
            subnet_ip             = "10.10.20.0/24"
            subnet_region         = "us-west1"
            subnet_private_access = "true"
            subnet_flow_logs      = "true"
            description           = "subnet for backends services"
        },
        {
            subnet_name               = "${var.env}-subnet-03"
            subnet_ip                 = "10.10.30.0/24"
            subnet_region             = "us-west1"
            subnet_flow_logs          = "true"
            subnet_private_access     = "true"
            description               = "subnet for dbs"
        }
    ]

    secondary_ranges = {
        subnet-01 = [
            {
                range_name    = "${var.env}-subnet-01-secondary-01"
                ip_cidr_range = "192.168.64.0/24"
            },
        ]

        subnet-02 = []
    }

    routes = [
        {
            name                   = "egress-internet"
            description            = "route through IGW to access internet"
            destination_range      = "0.0.0.0/0"
            tags                   = "egress-inet"
            next_hop_internet      = "true"
        },
        {
            name                   = "app-proxy"
            description            = "route through proxy to reach app"
            destination_range      = "10.50.10.0/24"
            tags                   = "app-proxy"
            next_hop_instance      = "app-proxy-instance"
            next_hop_instance_zone = "us-west1-a"
        },
    ]
}

# module "vpc" {
#   source  = "terraform-google-modules/network/google"
#   version = "9.0.0"

#   project_id   = "${var.project}"
#   network_name = "${var.env}"
#   routing_mode = "GLOBAL"

#   subnets = [
#     {
#       subnet_name   = "${var.env}-subnet-01"
#       subnet_ip     = "10.${var.env == "dev" ? 10 : 20}.10.0/24"
#       subnet_region = "us-west1"
#     },
#   ]

#   secondary_ranges = {
#     "${var.env}-subnet-01" = []
#   }
# }
