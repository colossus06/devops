# Below Code will generate a secure private key with encoding
resource "tls_private_key" "kp" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
# Create the Key Pair
resource "aws_key_pair" "eksctlkp" {
  key_name   = "eksctlkp"  
  public_key = tls_private_key.kp.public_key_openssh
}
# Save file
resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.eksctlkp.key_name}.pem"
  content  = tls_private_key.kp.private_key_pem
}