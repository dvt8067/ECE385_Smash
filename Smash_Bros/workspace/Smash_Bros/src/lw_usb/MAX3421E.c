#define _MAX3421E_C_

#include "stdlib.h"
#include "stdio.h"
#include "string.h"
#include "../../src/lw_usb/project_config.h"
#include "xparameters.h"
#include <unistd.h>
#include <xspi.h>
#include <xgpio.h>
#include <xtmrctr.h>
#include "xintc.h"

/* variables and data structures */

/* External variables */

extern BYTE usb_task_state;
static XSpi SpiInstance;
static int Status;
static XGpio Gpio_rst;
static XGpio Gpio_int;
static XSpi_Config *ConfigPtr;  /* Pointer to Configuration data */
XTmrCtr Usb_timer;

//Initialization of SPI port is already done for you
void SPI_init() {

    xil_printf("Initializing SPI\n");

    ConfigPtr = XSpi_LookupConfig(XPAR_SPI_USB_DEVICE_ID);
    if (ConfigPtr == NULL) {
        return XST_DEVICE_NOT_FOUND;
    }

    Status = XSpi_CfgInitialize(&SpiInstance, ConfigPtr,
                  ConfigPtr->BaseAddress);
    if (Status != XST_SUCCESS) {
        return XST_FAILURE;
    }

    if (Status != XST_SUCCESS)
    {
        xil_printf ("SPI device failed to initialize %d", Status);
    }
    Status = XSpi_SetOptions(&SpiInstance, XSP_MASTER_OPTION | XSP_MANUAL_SSELECT_OPTION);
    if (Status != XST_SUCCESS)
    {
        xil_printf ("SPI device failed to go into master mode %d", Status);
    }

    XSpi_Start(&SpiInstance);
    XSpi_IntrGlobalDisable(&SpiInstance);
}

BYTE SPI_wr(BYTE data) {
    return 0; //This function is not needed
}


/* Functions    */
/* Single host register write   */
void MAXreg_wr(BYTE reg, BYTE val) {
    //psuedocode:
    //select MAX3421E

    //XSpi_SetSlaveSelect(XSpi *InstancePtr, u32 SlaveMask);
    XSpi_SetSlaveSelect(&SpiInstance, SpiInstance.SlaveSelectMask);

    //write reg + 2 via SPI
    //reg+= 2 is this supposed to be the send/recieve buffer?
    u8 writeBuffer[2];
    writeBuffer[0] = reg+2;
    writeBuffer[1] = val;

    //write val via SPI

    // int XSpi_Transfer(XSpi *InstancePtr, u8 *SendBufPtr, u8 *RecvBufPtr, unsigned int ByteCount);

    //read return code from SPI peripheral (see Xilinx examples)
        //if return code != 0 print an error
    int Status = XSpi_Transfer(&SpiInstance, writeBuffer, NULL, 2);
    if(Status != 0){
        xil_printf("Error: Something went wrong when transferring the data");
    }
    XSpi_SetSlaveSelect(&SpiInstance, 0);
    //not sure if I need to deselect or not
    //deselect MAX3421E (may not be necessary if you are using SPI peripheral)

}


/* multiple-byte write */
/* returns a pointer to a memory position after last written */
BYTE* MAXbytes_wr(BYTE reg, BYTE nbytes, BYTE* data) {
    //psuedocode:
    //select MAX3421E (may not be necessary if you are using SPI peripheral)
    XSpi_SetSlaveSelect(&SpiInstance, SpiInstance.SlaveSelectMask);
    u8 writeBuffer[nbytes+1];
    //xil_printf(" Max READ ");

    //write reg + 2 via SPI
    writeBuffer[0] = reg+2;
    //write data[n] via SPI, where n goes from 0 to nbytes-1

    for(int i = 1; i< nbytes; i++){

        writeBuffer[i] = *(data + i-1); // This may be considered a magic #!!! basically need to write each datablock -- THIS IS SUS
    } // into this writeBuffer array

    //read return code from SPI peripheral

    int Status = XSpi_Transfer(&SpiInstance, writeBuffer, NULL, nbytes+1);

    //if return code != 0 print an error
    if(Status != 0){
            xil_printf("Error: Something went wrong when transferring the data");
    }
    XSpi_SetSlaveSelect(&SpiInstance, 0);

    //deselect MAX3421E (may not be necessary if you are using SPI peripheral)
    //return (data + nbytes);

    return data + nbytes; //IS THIS WHAT IT WANTS?
}

/* Single host register read        */
BYTE MAXreg_rd(BYTE reg) {
    //psuedocode:
    //select MAX3421E (
    XSpi_SetSlaveSelect(&SpiInstance, SpiInstance.SlaveSelectMask);

    //write reg via SPI
    u8 writeBuffer[2];
    writeBuffer[0] = reg;
    writeBuffer[1] = 0;
    u8 readBuffer[2];

    int Status = XSpi_Transfer(&SpiInstance, writeBuffer, readBuffer, 2);
    if(Status != 0){
                xil_printf("Error: Something went wrong when transferring the data");
    }
    //read val via SPI
    u8 Value = readBuffer[1];
    XSpi_SetSlaveSelect(&SpiInstance, 0);
    return Value;
    //read return code from SPI peripheral
    //if return code != 0 print an error
    //deselect MAX3421E (may not be necessary if you are using SPI peripheral)
    //return val
}



/* multiple-bytes register read                             */
/* returns a pointer to a memory position after last read   */
BYTE* MAXbytes_rd(BYTE reg, BYTE nbytes, BYTE* data) {
    //psuedocode:
    //select MAX3421E (may not be necessary if you are using SPI peripheral)
    XSpi_SetSlaveSelect(&SpiInstance, SpiInstance.SlaveSelectMask);

    //write reg via SPI
    u8 writeBuffer[nbytes+1];
    writeBuffer[0] = reg;
    u8 readBuffer[nbytes+1];
    //xil_printf(" Max write ");

    int Status = XSpi_Transfer(&SpiInstance, writeBuffer, readBuffer, nbytes+1);
    if(Status != 0){
                xil_printf("Error: Something went wrong when transferring the data");
    }
    for(int i=0; i<nbytes+1; i++){
        if(i==0){
            continue;
        }
        *(data+ i-1) = readBuffer[i];
    }
    //read data[n] from SPI, where n goes from 0 to nbytes-1
    //read return code from SPI peripheral
    //if return code != 0 print an error
    //deselect MAX3421E (may not be necessary if you are using SPI peripheral)
    //return (data + nbytes);
    XSpi_SetSlaveSelect(&SpiInstance, 0);
    return (data + nbytes);
}
/* reset MAX3421E using chip reset bit. SPI configuration is not affected   */
void MAX3421E_reset(void) {
    Status = XGpio_Initialize(&Gpio_rst, XPAR_GPIO_USB_RST_DEVICE_ID);
    XGpio_SetDataDirection(&Gpio_rst, 1, 0); //configure reset, and set reset to output
    Status = XGpio_Initialize(&Gpio_int, XPAR_GPIO_USB_INT_DEVICE_ID);
    XGpio_SetDataDirection(&Gpio_int, 1, ~1); //configure int, and set int to input


    //hardware reset, then software reset
    XGpio_DiscreteClear(&Gpio_rst, 1, 0x1);
    xil_printf ("Holding USB in Reset\n");
    for (int delay = 0; delay < 0x7FFFF; delay ++){}
    XGpio_DiscreteSet(&Gpio_rst, 1, 0x1);
    xil_printf ("Revision is: %d, if this reads 0 check your MAXreg_rd \n", MAXreg_rd( rREVISION));
    BYTE tmp = 0;

    MAXreg_wr( rUSBCTL, bmCHIPRES);      //Chip (soft) reset. This stops the oscillator
    MAXreg_wr( rUSBCTL, 0x00);           //Remove the reset

    xil_printf("Waiting for PLL to stabilize: ");
    while (!(MAXreg_rd( rUSBIRQ) & bmOSCOKIRQ)) { //wait until the PLL stabilizes
        tmp++;                                      //timeout after 256 attempts
        xil_printf(".\n");
        if (tmp == 0) {
            xil_printf("reset timeout!, check your MAXreg_wr\n");
        }
    }
}
/* turn USB power on/off                                                */
/* ON pin of VBUS switch (MAX4793 or similar) is connected to GPOUT0    */
/* OVERLOAD pin of Vbus switch is connected to GPIN7                    */
/* OVERLOAD state low. NO OVERLOAD or VBUS OFF state high.              */
BOOL Vbus_power(BOOL action) {
    BYTE tmp = MAXreg_rd( rIOPINS1 );       //copy of IOPINS2
    if( action ) {                              //turn on by setting GPOUT0
        tmp |= bmGPOUT0;
    }
    else {                                      //turn off by clearing GPOUT0
        tmp &= ~bmGPOUT0;
    }
    MAXreg_wr( rIOPINS1,tmp );                              //send GPOUT0
    for (int delay = 0; delay < 0xFFFFF; delay ++){}        //delay a couple MS
    xil_printf ("VBUS power state change \n");
    return( TRUE );                                         // power on/off successful
    return (1);
}

/* probe bus to determine device presence and speed */
void MAX_busprobe(void) {
    BYTE bus_sample;

//  MAXreg_wr(rHCTL,bmSAMPLEBUS);
    bus_sample = MAXreg_rd( rHRSL);            //Get J,K status
    bus_sample &= ( bmJSTATUS | bmKSTATUS);      //zero the rest of the byte

    switch (bus_sample) {                   //start full-speed or low-speed host
    case ( bmJSTATUS):
        /*kludgy*/
        if (usb_task_state != USB_ATTACHED_SUBSTATE_WAIT_RESET_COMPLETE) { //bus reset causes connection detect interrupt
            if (!(MAXreg_rd( rMODE) & bmLOWSPEED)) {
                MAXreg_wr( rMODE, MODE_FS_HOST);         //start full-speed host
                xil_printf("Starting in full speed\n");
            } else {
                MAXreg_wr( rMODE, MODE_LS_HOST);    //start low-speed host
                xil_printf("Starting in low speed\n");
            }
            usb_task_state = ( USB_STATE_ATTACHED); //signal usb state machine to start attachment sequence
        }
        break;
    case ( bmKSTATUS):
        if (usb_task_state != USB_ATTACHED_SUBSTATE_WAIT_RESET_COMPLETE) { //bus reset causes connection detect interrupt
            if (!(MAXreg_rd( rMODE) & bmLOWSPEED)) {
                MAXreg_wr( rMODE, MODE_LS_HOST);   //start low-speed host
                xil_printf("Starting in low speed\n");
            } else {
                MAXreg_wr( rMODE, MODE_FS_HOST);         //start full-speed host
                xil_printf("Starting in full speed\n");
            }
            usb_task_state = ( USB_STATE_ATTACHED); //signal usb state machine to start attachment sequence
        }
        break;
    case ( bmSE1):              //illegal state
        usb_task_state = ( USB_DETACHED_SUBSTATE_ILLEGAL);
        break;
    case ( bmSE0):              //disconnected state
        if (!((usb_task_state & USB_STATE_MASK) == USB_STATE_DETACHED)) //if we came here from other than detached state
            usb_task_state = ( USB_DETACHED_SUBSTATE_INITIALIZE); //clear device data structures
        else {
            MAXreg_wr( rMODE, MODE_FS_HOST); //start full-speed host
            usb_task_state = ( USB_DETACHED_SUBSTATE_WAIT_FOR_DEVICE);
        }
        break;
    } //end switch( bus_sample )
}
/* MAX3421E initialization after power-on   */
void MAX3421E_init(void) {
    /* Configure full-duplex SPI, interrupt pulse   */
    SPI_init();
    MAXreg_wr( rPINCTL, (bmFDUPSPI + bmINTLEVEL + bmGPXB)); //Full-duplex SPI, level interrupt, GPX
    MAX3421E_reset();                                //stop/start the oscillator

    //start USB timer
    Status = XTmrCtr_Initialize(&Usb_timer, XPAR_TIMER_USB_AXI_DEVICE_ID);
    if (Status != XST_SUCCESS) {
            xil_printf ("Timer instantiation failed\n");
    }
    XTmrCtr_Start(&Usb_timer, 0);

    xil_printf ("The following should be about 1 second ticks. If they are not, check your timer \n");
    //Test timer to make sure it is plausible
    for (int i = 0; i < 3; i++)
    {
        u32 current = XTmrCtr_GetValue(&Usb_timer, 0);
        while (XTmrCtr_GetValue(&Usb_timer, 0) - current < 100000000)
        {

        }
        xil_printf (".tick.\n");
    }

    /* configure power switch   */
    Vbus_power( OFF);                                      //turn Vbus power off
    //MAXreg_wr( rGPINIEN, bmGPINIEN7); //enable interrupt on GPIN7 (power switch overload flag)
    Vbus_power( ON);
    /* configure host operation */
    MAXreg_wr( rMODE, bmDPPULLDN | bmDMPULLDN | bmHOST | bmSEPIRQ); // set pull-downs, SOF, Host, Separate GPIN IRQ on GPX
    //MAXreg_wr( rHIEN, bmFRAMEIE|bmCONDETIE|bmBUSEVENTIE );                      // enable SOF, connection detection, bus event IRQs
    MAXreg_wr( rHIEN, bmCONDETIE);                        //connection detection
    /* HXFRDNIRQ is checked in Dispatch packet function */
    MAXreg_wr(rHCTL, bmSAMPLEBUS);        // update the JSTATUS and KSTATUS bits
    MAX_busprobe();                             //check if anything is connected
    MAXreg_wr( rHIRQ, bmCONDETIRQ); //clear connection detect interrupt
    MAXreg_wr( rCPUCTL, 0x01);                            //enable interrupt pin
}

/* MAX3421 state change task and interrupt handler */
void MAX3421E_Task(void) {
    if (XGpio_DiscreteRead(&Gpio_int, 1) & 0x01 == 0) {
        xil_printf("MAX interrupt\n\r");
        MaxIntHandler();
    }
    //if ( IORD_ALTERA_AVALON_PIO_DATA(USB_GPX_BASE) == 1) {
    //  xil_printf("GPX interrupt\n\r");
    //  MaxGpxHandler();
    //}
}

void MaxIntHandler(void) {
    BYTE HIRQ;
    BYTE HIRQ_sendback = 0x00;
    HIRQ = MAXreg_rd( rHIRQ);                  //determine interrupt source
    xil_printf("IRQ: %x\n", HIRQ);
    if (HIRQ & bmFRAMEIRQ) {                   //->1ms SOF interrupt handler
        HIRQ_sendback |= bmFRAMEIRQ;
    }                   //end FRAMEIRQ handling

    if (HIRQ & bmCONDETIRQ) {
        MAX_busprobe();
        HIRQ_sendback |= bmCONDETIRQ;      //set sendback to 1 to clear register
    }
    if (HIRQ & bmSNDBAVIRQ) //if the send buffer is clear (previous transfer completed without issue)
    {
        MAXreg_wr(rSNDBC, 0x00);//clear the send buffer (not really necessary, but clears interrupt)
    }
    if (HIRQ & bmBUSEVENTIRQ) {           //bus event is either reset or suspend
        usb_task_state++;                       //advance USB task state machine
        HIRQ_sendback |= bmBUSEVENTIRQ;
    }
    /* End HIRQ interrupts handling, clear serviced IRQs    */
    MAXreg_wr( rHIRQ, HIRQ_sendback); //write '1' to CONDETIRQ to ack bus state change
}

void MaxGpxHandler(void) {
    BYTE GPINIRQ;
    GPINIRQ = MAXreg_rd( rGPINIRQ);            //read both IRQ registers
}
