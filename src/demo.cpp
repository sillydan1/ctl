#include <iostream>
#include <types.h>
#include <Tree.hpp>
// Add this, otherwise it will not compile. TODO: This shouldn't be necessary
extern Tree<ASTNode>* ParseQuery(const std::string&);

int main() {
    // Query: "Does it, for all paths, always hold that the 'my_test_var' is true?"
	auto* q = ParseQuery("A G my_test_var == true and other == false");

	q->tree_apply([](ASTNode& n) {
        std::cout << "TYPE: " << ConvertToString(n.type) << " - Token: " << n.token << "\n";
	});

	if(q)
	    return 0;
	else
	    return 1;
}
