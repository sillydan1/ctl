#include "QueryPrintVisitor.h"

void QueryPrintVisitor::Print(const Literal &l) {
    printf(" %s ", l.expression_string.c_str());
}

void QueryPrintVisitor::Print(const VariableIdentifier &v) {
    printf(" %s ", v.expression_string.c_str());
}

void QueryPrintVisitor::Print(const LocationIdentifier &l) {
    printf(" %s ", l.expression_string.c_str());
}

void QueryPrintVisitor::Print(const Deadlock &d) {
    printf(" %s ", d.expression_string.c_str());
}

void QueryPrintVisitor::Print(const LogicOperator &l) {
    l.left->accept(*this);
    switch (l.type) {
        case LogicOperator::OperatorType::AND: printf("AND"); break;
        case LogicOperator::OperatorType::OR: printf("OR"); break;
        case LogicOperator::OperatorType::UNKNOWN:
        default: printf("WHAT?!"); break;
    }
    l.right->accept(*this);
}

void QueryPrintVisitor::Print(const NegationOperator &n) {
    printf("!(");
    n.subExpression->accept(*this);
    printf(")");
}

void QueryPrintVisitor::Print(const Comparator &c) {
    c.left->accept(*this);
    switch (c.type) {
        case Comparator::CompareType::LESSTHAN: printf("<"); break;
        case Comparator::CompareType::LESSTHANEQUAL: printf("<="); break;
        case Comparator::CompareType::NOTEQUAL: printf("!="); break;
        case Comparator::CompareType::EQUAL: printf("=="); break;
        case Comparator::CompareType::GREATERTHAN: printf(">"); break;
        case Comparator::CompareType::GREATERTHANEQUAL: printf(">="); break;
        case Comparator::CompareType::UNKNOWN:
        default: printf("WHAT?!"); break;
    }
    c.right->accept(*this);
}

void QueryPrintVisitor::Print(const SubExpression &e) {
    printf("(");
    e.expr->accept(*this);
    printf(")");
}

void QueryPrintVisitor::Print(const Finally &f) {
    printf("<>");
    f.expression->accept(*this);
}

void QueryPrintVisitor::Print(const Globally &g) {
    printf("[]");
    g.expression->accept(*this);
}

void QueryPrintVisitor::Print(const Next &n) {
    printf("X");
    n.expression->accept(*this);
}

void QueryPrintVisitor::Print(const Until &u) {
    printf("U");
    u.expression->accept(*this);
}

void QueryPrintVisitor::Print(const Exists &e) {
    printf("E");
    e.quantifier->accept(*this);
}

void QueryPrintVisitor::Print(const Forall* f) {
    printf("A");
    f->quantifier->accept(*this);
}

void QueryPrintVisitor::Print(const Visitable* v) const {
    printf("Flowers and anal sex");
}
