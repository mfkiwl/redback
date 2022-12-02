/****************************************************************/
/* MOOSE - Multiphysics Object Oriented Simulation Environment  */
/*                                                              */
/*          All contents are licensed under LGPL V2.1           */
/*             See LICENSE for full restrictions                */
/****************************************************************/

#ifndef GENERICCONSTANTVECTOR_H
#define GENERICCONSTANTVECTOR_H

#include "Material.h"

/**
 * Declares a constant material property of type RankTwoTensor.
 */
class GenericConstantVector : public Material
{
public:
  GenericConstantVector(const InputParameters & parameters);
  static InputParameters validParams();

protected:
  virtual void computeQpProperties() override;

  RealVectorValue _vector;
  MaterialProperty<RealVectorValue> & _prop;
};

#endif // GENERICCONSTANTVECTOR_H
