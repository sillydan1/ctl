#ifndef CTLPARSER_QUERYPRINTVISITOR_H
#define CTLPARSER_QUERYPRINTVISITOR_H
#include "types.h"

class QueryPrintVisitor : Visitor {
public:
    void Print(const Literal& l);
    void Print(const VariableIdentifier& v);
    void Print(const LocationIdentifier& l);
    void Print(const Deadlock& d);
    void Print(const LogicOperator& l);
    void Print(const NegationOperator& n);
    void Print(const Comparator& c);
    void Print(const SubExpression& e);

    void Print(const Finally& f);
    void Print(const Globally& g);
    void Print(const Next& n);
    void Print(const Until& u);

    void Print(const Exists& e);
    void Print(const Forall* f);

    void Print(const Visitable* v) const override;
};

#endif //CTLPARSER_QUERYPRINTVISITOR_H
