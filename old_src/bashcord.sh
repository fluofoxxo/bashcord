#include "util.sh"
#include "client.sh"

start() {
	configure
	connect
	pulse &
	receiver &
}
