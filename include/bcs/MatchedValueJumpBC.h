/****************************************************************/
/*               DO NOT MODIFY THIS HEADER                      */
/*     REDBACK - Rock mEchanics with Dissipative feedBACKs      */
/*                                                              */
/*              (c) 2014 CSIRO and UNSW Australia               */
/*                   ALL RIGHTS RESERVED                        */
/*                                                              */
/*            Prepared by CSIRO and UNSW Australia              */
/*                                                              */
/*            See COPYRIGHT for full restrictions               */
/****************************************************************/

#ifndef MATCHEDVALUEJUMPBC_H
#define MATCHEDVALUEJUMPBC_H

#include "NodalBC.h"

/**
 * Implements a simple coupled boundary condition where u=v on the boundary.
 */
class MatchedValueJumpBC : public NodalBC
{
public:
  MatchedValueJumpBC(const InputParameters & parameters);

  static InputParameters validParams();

protected:
  virtual Real computeQpResidual() override;
  virtual Real computeQpOffDiagJacobian(unsigned int jvar) override;

  const VariableValue & _v;

  /// The id of the coupled variable
  unsigned int _v_num;

  const VariableValue & _tangent_jump;
  const unsigned int _component;
  const MooseArray<Point> & _normals;
};

#endif // MATCHEDVALUEJUMPBC_H
