#include <types.h>
#include <QueryPrintVisitor.h>
// Add this, otherwise it will not compile. TODO: This shouldn't be necessary
extern Query* ParseQuery(const std::string&);

int main() {
    // Query: "Does it, for all paths, always hold that the 'my_test_var' is true?"
	auto* q = ParseQuery("A G my_test_var == true and other == false");
	QueryPrintVisitor v{};
	v.Print(q);
	delete q; // Set a debug-break here to inspect the type if you like
}
