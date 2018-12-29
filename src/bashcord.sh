#include "util.sh"
#include "api.sh"
#include "ops.sh"
#include "controller.sh"

require curl jq websocat

start() {
	configure
	connect
	receiver &
	ticker &
}
