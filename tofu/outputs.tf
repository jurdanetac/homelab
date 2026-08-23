output "vm_arr_ip" {
  description = "Static IP of the arr VM"
  value       = var.vm_arr_ip
}
output "vm_arr_id" {
  description = "VM ID of the arr VM"
  value       = proxmox_virtual_environment_vm.vm_arr.vm_id
}