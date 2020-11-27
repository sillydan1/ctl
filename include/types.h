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

NodeType_t FromString(const std::string& string) {
    // Comparator
    if(string == "<") return NodeType_t::CompLess;
    if(string == "<=") return NodeType_t::CompLessEq;
    if(string == "!=") return NodeType_t::CompNeq;
    if(string == "==") return NodeType_t::CompEq;
    if(string == ">=") return NodeType_t::CompGreaterEq;
    if(string == ">") return NodeType_t::CompGreater;
    // Logic and / or
    if(string == "&&") return NodeType_t::LogicAnd;
    if(string == "and")return NodeType_t::LogicAnd;
    if(string == "||") return NodeType_t::LogicOr;
    if(string == "or") return NodeType_t::LogicOr;
    return NodeType_t::UNKNOWN; // There is something very wrong, my dude
}

struct ASTNode {
    NodeType_t type;
    std::string token;

    explicit ASTNode(std::string token) : type{FromString(token)}, token{std::move(token)} {}
    ASTNode(const NodeType_t& type, std::string token) : type{type}, token{std::move(token)} {}
};

#endif // TYPES_H
