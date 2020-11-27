#ifndef TYPES_H
#define TYPES_H
#include <string>
#include <utility>

enum class NodeType_t : unsigned int {
    Literal, Var, Location, Deadlock,
    LogicAnd, LogicOr,
    Negation,
    CompLess, CompLessEq, CompNeq, CompEq, CompGreater, CompGreaterEq,
    SubExpr,
    Finally, Globally, Next, Until,
    Exists, Forall,
    UNKNOWN
};

NodeType_t FromString(const std::string& string);
std::string ConvertToString(const NodeType_t&);

struct ASTNode {
    NodeType_t type;
    std::string token;

    explicit ASTNode(std::string token) : type{FromString(token)}, token{std::move(token)} {}
    ASTNode(const NodeType_t& type, std::string token) : type{type}, token{std::move(token)} {}
};

#endif // TYPES_H
