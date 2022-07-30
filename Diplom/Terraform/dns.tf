
# Creating public DNS zone 
resource "yandex_dns_zone" "vpc-zone" {
  name             = "vpc-public-zone"
  zone             = "${var.domain}."
  public           = true
}

# Creating main A-record
resource "yandex_dns_recordset" "a1" {
  zone_id = yandex_dns_zone.vpc-zone.id
  name    = "${var.domain}."
  type    = "A"
  ttl     = 90
  data    = [yandex_compute_instance.ycn1nginx.network_interface.0.nat_ip_address]
  depends_on = [yandex_compute_instance.ycn1nginx]
}

# Creating A-records for L3-domains
resource "yandex_dns_recordset" "a2" {
  zone_id = yandex_dns_zone.vpc-zone.id
  name    = "www"
  type    = "A"
  ttl     = 90
  data    = [yandex_compute_instance.ycn1nginx.network_interface.0.nat_ip_address]
  depends_on = [yandex_compute_instance.ycn1nginx]
}

resource "yandex_dns_recordset" "a3" {
  zone_id = yandex_dns_zone.vpc-zone.id
  name    = "gitlab"
  type    = "A"
  ttl     = 90
  data    = [yandex_compute_instance.ycn1nginx.network_interface.0.nat_ip_address]
  depends_on = [yandex_compute_instance.ycn1nginx]
}

resource "yandex_dns_recordset" "a4" {
  zone_id = yandex_dns_zone.vpc-zone.id
  name    = "grafana"
  type    = "A"
  ttl     = 90
  data    = [yandex_compute_instance.ycn1nginx.network_interface.0.nat_ip_address]
  depends_on = [yandex_compute_instance.ycn1nginx]
}

resource "yandex_dns_recordset" "a5" {
  zone_id = yandex_dns_zone.vpc-zone.id
  name    = "prometheus"
  type    = "A"
  ttl     = 90
  data    = [yandex_compute_instance.ycn1nginx.network_interface.0.nat_ip_address]
  depends_on = [yandex_compute_instance.ycn1nginx]
}

resource "yandex_dns_recordset" "a6" {
  zone_id = yandex_dns_zone.vpc-zone.id
  name    = "alertmanager"
  type    = "A"
  ttl     = 90
  data    = [yandex_compute_instance.ycn1nginx.network_interface.0.nat_ip_address]
  depends_on = [yandex_compute_instance.ycn1nginx]
}
