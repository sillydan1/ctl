#include <iostream>
#include <types.h>
#include <Tree.hpp>
// Add this, otherwise it will not compile. TODO: This shouldn't be necessary
extern Tree<ASTNode>* ParseQuery(const std::string&);

int main() {
    // Query: "Does it, for all paths, always hold that the 'my_test_var' is true?"
	auto* q = ParseQuery("A G my_test_var == true and other == false");
    // Now visit the tree with either "tree_apply" or "tree_accumulate". These functions visit the tree DFS-style
	q->tree_apply([](ASTNode& n) {
	    // This will simply print the node
        std::cout << "TYPE: " << ConvertToString(n.type) << ", Token: " << n.token << "\n";
	});
	delete q; // Make sure to delete the query again. Alternatively, you can wrap it in a std::unique_ptr
}
