/// Power Channel for equipment power users
#define PW_CHANNEL_EQUIPMENT	1
/// Power chanel for lighting power users
#define PW_CHANNEL_LIGHTING		2
/// Power channel for environmental power users
#define PW_CHANNEL_ENVIRONMENT	3

/// Local powernet in this area will never be powered, even if its recieving power
#define PW_ALWAYS_UNPOWERED       (1 << 0)
/// Local powernet in this area will always have power even if its not recieving power
#define PW_ALWAYS_POWERED         (1 << 1)

/// roughly 1/2000 chance of a machine flickering on any given tick. That means in a two hour round each machine will flicker on average a little less than two times.
#define MACHINE_FLICKER_CHANCE 0.05

// bitflags for machine stat variable
/// Machine is broken
#define BROKEN		(1 << 0)
/// Machine is not recieving any power from the local powernet
#define NOPOWER		(1 << 1)
/// machine is currently under maintenance
#define MAINT		(1 << 2)
/// Machine is currently affected by EMP pulse
#define EMPED		(1 << 3)

//Power use
/// This machine is not currently consuming any power passively
#define NO_POWER_USE 0
/// This machine is consuming its idle power amount passively
#define IDLE_POWER_USE 1
/// This machine is consuming its active power amount passively
#define ACTIVE_POWER_USE 2

//APC charging
/// APC is not recieving power
#define APC_NOT_CHARGING 0
/// APC is currently recieving power and storing it
#define APC_IS_CHARGING 1
/// APC battery is at 100%
#define APC_FULLY_CHARGED 2

// Power ERROR Codes
#define PW_ERROR_WRONG_VOLTAGE	-1
#define PW_ERROR_DISCONNECTED	-2

#define VOLTAGE_LOW 	1
#define VOLTAGE_HIGH	2
/// Uses both types of voltage in this machine
#define VOLTAGE_BOTH	3

#define PW_CONNECTION_NODE 1
#define PW_CONNECTION_CONNECTOR 2

#define MACHINE_ELECTRIFIED_NONE	0
#define MACHINE_ELECTRIFIED_BUZZ	1
#define MACHINE_ELECTRIFIED_BURN	2
#define MACHINE_ELECTRIFIED_SHOCK	3
#define MACHINE_ELECTRIFIED_THROW	4
#define MACHINE_ELECTRIFIED_YEET	5
#define MACHINE_ELECTRIFIED_FUCK_ME_UP_CHIEF 6
