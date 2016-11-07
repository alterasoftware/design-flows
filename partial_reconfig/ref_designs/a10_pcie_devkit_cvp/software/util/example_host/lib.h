// Copyright (C) 2001-2016 Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions
// and other software and tools, and its AMPP partner logic
// functions, and any output files from any of the foregoing
// (including device programming or simulation files), and any
// associated documentation or information are expressly subject
// to the terms and conditions of the Intel Program License
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel MegaCore Function License Agreement, or other
// applicable license agreement, including, without limitation,
// that your use is for the sole purpose of programming logic
// devices manufactured by Intel and sold by Intel or its
// authorized distributors.  Please refer to the applicable
// agreement for further details.


#ifndef LIB_H
#define LIB_H
#include <stdlib.h>
#include <string.h>
#include <malloc.h>
#include <unistd.h>
#include <fcntl.h>
#include <string>
#include <iostream>
#include "pcie_linux_driver_exports.h"

//define some needed data types
typedef unsigned int        uintptr_t;
typedef unsigned int        DWORD;
typedef unsigned long long  QWORD;
#define INVALID_DEVICE (-1)

typedef ssize_t WDC_DEVICE_HANDLE;

int save_pci_control_regs(WDC_DEVICE_HANDLE m_device);

int load_pci_control_regs(WDC_DEVICE_HANDLE m_device);

WDC_DEVICE_HANDLE open_device_linux(int dev_num);

bool program_over_jtag(const std::string& filename, bool use_sof, const std::string& cable, const std::string& device_index, bool slow_jtag);

int disable_interrupts(WDC_DEVICE_HANDLE m_device);

int program_core_with_PR ( WDC_DEVICE_HANDLE device, char *core_bitstream, size_t core_rbf_len);


template<typename T>
DWORD linux_read ( WDC_DEVICE_HANDLE device, DWORD bar, uintptr_t address, T *data )
{
   struct acl_cmd driver_cmd;
   driver_cmd.bar_id         = bar;
   driver_cmd.command        = ACLPCI_CMD_DEFAULT;
   driver_cmd.device_addr    = reinterpret_cast<void *>(address);
   driver_cmd.user_addr      = data;
   driver_cmd.size           = sizeof(*data);
   // function invoke linux_read will not write to global memory.
   // So is_diff_endian is always false
   driver_cmd.is_diff_endian = 0;

   return read (device, &driver_cmd, sizeof(driver_cmd));
}

template<typename T>
DWORD linux_write ( WDC_DEVICE_HANDLE device, DWORD bar, uintptr_t address, T data )
{
   struct acl_cmd driver_cmd;
   driver_cmd.bar_id         = bar;
   driver_cmd.command        = ACLPCI_CMD_DEFAULT;
   driver_cmd.device_addr    = reinterpret_cast<void *>(address);
   driver_cmd.user_addr      = &data;
   driver_cmd.size           = sizeof(data);
   // function invoke linux_write will not write to global memory.
   // So is_diff_endian is always false
   driver_cmd.is_diff_endian = 0;

   return write (device, &driver_cmd, sizeof(driver_cmd));
}


#endif // LIB_H
