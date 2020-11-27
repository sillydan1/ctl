#include <types.h>

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
    return NodeType_t::UNKNOWN; // There is something very wrong my dude
}

// Should be used primarily for debugging
std::string ConvertToString(const NodeType_t& t) {
    switch(t) {
        case NodeType_t::Literal: return "Literal";
        case NodeType_t::Var: return "Var";
        case NodeType_t::Location: return "Location";
        case NodeType_t::Deadlock: return "Deadlock";
        case NodeType_t::LogicAnd: return "LogicAnd";
        case NodeType_t::LogicOr: return "LogicOr";
        case NodeType_t::Negation: return "Negation";
        case NodeType_t::CompLess: return "CompLess";
        case NodeType_t::CompLessEq: return "CompLessEq";
        case NodeType_t::CompNeq: return "CompNeq";
        case NodeType_t::CompEq: return "CompEq";
        case NodeType_t::CompGreater: return "CompGreater";
        case NodeType_t::CompGreaterEq: return "CompGreaterEq";
        case NodeType_t::SubExpr: return "SubExpr";
        case NodeType_t::Finally: return "Finally";
        case NodeType_t::Globally: return "Globally";
        case NodeType_t::Next: return "Next";
        case NodeType_t::Until: return "Until";
        case NodeType_t::Exists: return "Exists";
        case NodeType_t::Forall: return "Forall";
        case NodeType_t::UNKNOWN:
        default: return "UNKNOWN";
    }
}
