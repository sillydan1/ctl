#include "../include/types.h"

extern Query* ParseQuery(const std::string&);

int main(void) {
	auto* q = ParseQuery("A G Hello == true");
	q = ParseQuery("E F deadlock");
	return 0;
}
