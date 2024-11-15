#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vtoplevel.h"

#include "vbuddy.cpp" // include vbuddy code
#define MAX_SIM_CYC 1000000
#define ADDRESS_WIDTH 8
#define ROM_SZ 256

int main(int argc, char **argv, char **env)
{
    int simcyc; // simulation clock count
    int tick;   // each clk cycle has two ticks for two edges
    int lights = 0;

    Verilated::commandArgs(argc, argv);
    // init top verilog instance
    Vtoplevel *top = new Vtoplevel;
    // init trace dump
    Verilated::traceEverOn(true);
    VerilatedVcdC *tfp = new VerilatedVcdC;
    top->trace(tfp, 99);
    tfp->open("toplevel.vcd");

    // init Vbuddy
    if (vbdOpen() != 1)
        return (-1);
    vbdHeader("L3:T3 F1 Lights");
    // vbdSetMode(1);        // Flag mode set to one-shot

    // initialize simulation inputs
    top->clk = 1;
    top->rst = 0;
    top->en = 0;
    top->N = 57;

    // run simulation for MAX_SIM_CYC clock cycles
    for (simcyc = 0; simcyc < MAX_SIM_CYC; simcyc++)
    {
        // dump variables into VCD file and toggle clock
        for (tick = 0; tick < 2; tick++)
        {
            tfp->dump(2 * simcyc + tick);
            top->clk = !top->clk;
            top->eval();
        }

        vbdBar(lights);
        lights = (top->dout & 0xFF);

        // set up input signals of testbench
        top->rst = (simcyc < 2); // assert reset for 1st cycle
        top->en = (simcyc > 2);
        top->N = vbdValue();
        vbdCycle(simcyc);

        // either simulation finished, or 'q' is pressed
        if ((Verilated::gotFinish()) || (vbdGetkey() == 'q'))
            exit(0); // ... exit if finish OR 'q' pressed
    }

    vbdClose(); // ++++
    tfp->close();
    exit(0);
}