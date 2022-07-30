# Network
resource "yandex_vpc_network" "vpc-net" {
  name = "vpc"
}

# Public Subnet in zone b
resource "yandex_vpc_subnet" "pub-subnet" {
  name = "pubsubnet"
  zone           = "ru-central1-b"
  network_id     = "${yandex_vpc_network.vpc-net.id}"
  v4_cidr_blocks = ["10.10.10.0/28"]
}

# Routing Table for Private Subnet
resource "yandex_vpc_route_table" "natinst" {
  network_id = "${yandex_vpc_network.vpc-net.id}"

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "10.10.10.10"
  }
}

# Private Subnet in zone a
resource "yandex_vpc_subnet" "priv-subnet" {
  name = "privsubnet"
  zone           = "ru-central1-a"
  network_id     = "${yandex_vpc_network.vpc-net.id}"
  route_table_id = "${yandex_vpc_route_table.natinst.id}"
  v4_cidr_blocks = ["10.10.11.0/27"]
}
