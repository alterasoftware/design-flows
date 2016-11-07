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


//This is a quartus_pgm wrapper that saves the PCIe control registers to allow full chip programming to be done
//without needing to reboot the host computer

//import functions for saving and loading configurations
#include "lib.h"
#include <fstream>


//PCI IP constants
#include "hw_pcie_constants.h"
#include "version.h"
#include "pcie_linux_driver_exports.h"

int main (int argc, char *argv[]){
    int dev_num = 0;
    std::string filename = "";

    std::string usage = "usage:\n-f <filename> \t\tthe name of the file to be used\n"
            "-h \t\t\thelp/usage\n";


    if ( argc == 1 )
    {
        std::cout <<"ERROR: a filename must be provided to this program\n\n\n";
        std::cout << usage;
        return 1;
    }
    else
    {

        std::string mystring = argv[1];
        
        if ( ( argc < 3 ) && ( mystring != "-h" ) )
        {
            std::cout <<"ERROR: a filename must be provided to this program\n\n\n";
            std::cout << usage;
            return 1;
        }
        else
        {
            for (int i = 1;i < argc; i++)
            {
                mystring = argv[i];

                if (mystring == "-f")
                {
                    filename = argv[i+1];
                    i++;
                }
                else if(mystring == "-h")
                {
                    std::cout << usage;
                    return 0;
                }
                else
                {
                    std::cout << "ERROR: Unrecognized argument\n";
                    std::cout << usage;
                    return 1;
                }
            }
        }
    }

    if (std::string(filename) == "")
    {
        std::cout <<"ERROR: a filename must be provided to this program\n\n\n";
        std::cout << usage;
        return 1;
    }


    std::ifstream fin(filename.c_str(), std::ios::binary);

    if (!fin.is_open())
    {
        std::cout << "ERROR: could not open file\n";
        return 1;
    }
    //get the size of the file
    fin.seekg (0, fin.end);
    int size_of_file = fin.tellg();

    fin.seekg (0, fin.beg);

    //store the file in local memory
    char *bitstream;
    bitstream= (char *) malloc(size_of_file);
    fin.read(bitstream,size_of_file);

    std::cout << "INFO: opening device\n";

    WDC_DEVICE_HANDLE m_device = open_device_linux(dev_num);
    if (m_device == INVALID_DEVICE)
    {
        std::cout << "ERROR: failed to open device, now exiting\n";
        return 1;
    }

    int pr_result=1;

    //do Partial Reconfiguration
    pr_result = program_core_with_PR( m_device, bitstream, size_of_file);
    if (pr_result)
    {
        std::cout << "ERROR: Could not PR the core\n";
    }
    else
    {
        std::cout << "INFO: PR of the core was successful\n";
    }

    fin.close();
    free(bitstream);
    std::cout << "INFO: closing device\n";
    close(m_device);
    return pr_result;
}
