class  ahb_agent extends uvm_agent;
`uvm_component_utils(ahb_agent)

ahb_driver ahb_drv;
ahb_monitor ahb_mon;
ahb_sequencer ahb_sqr;
ahb_agent_cfg cfg;

//-----METHODS----------
extern function new(string name="ahb_agent",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass


function ahb_agent :: new(string name="ahb_agent",uvm_component parent);
super.new(name,parent);
endfunction:new

function void ahb_agent :: build_phase(uvm_phase phase);

if(!uvm_config_db#(ahb_agent_cfg)::get(this,"","ahb_agent_cfg",cfg))
`uvm_fatal("AHB CONFIG","not able to get() from uvm_config_db. Have you set() it ")
super.build_phase(phase);
ahb_mon=ahb_monitor::type_id::create("ahb_mon",this);
if(cfg.is_active == UVM_ACTIVE )
begin
  ahb_drv=ahb_driver::type_id::create("ahb_drv",this);
  ahb_sqr=ahb_sequencer::type_id::create("ahb_sqr",this);
end 
endfunction:build_phase

function void ahb_agent ::connect_phase(uvm_phase phase);
if(cfg.is_active == UVM_ACTIVE)
	begin
		//connect the driver and sequencer using tlm port
		ahb_drv.seq_item_port.connect(ahb_sqr.seq_item_export);
	end
endfunction 
