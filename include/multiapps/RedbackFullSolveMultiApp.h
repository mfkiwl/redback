//* This file is part of the MOOSE framework
//* https://www.mooseframework.org
//*
//* All rights reserved, see COPYRIGHT for full restrictions
//* https://github.com/idaholab/moose/blob/master/COPYRIGHT
//*
//* Licensed under LGPL 2.1, please see LICENSE for details
//* https://www.gnu.org/licenses/lgpl-2.1.html

#ifndef REDBACKFULLSOLVEMULTIAPP_H
#define REDBACKFULLSOLVEMULTIAPP_H

#include "MultiApp.h"

class Executioner;
/**
 * This type of MultiApp will completely solve itself the first time it is asked to take a step.
 *
 * Each "step" after that it will do nothing.
 */
class RedbackFullSolveMultiApp : public MultiApp
{
public:
  RedbackFullSolveMultiApp(const InputParameters & parameters);
  static InputParameters validParams();

  virtual bool solveStep(Real dt, Real target_time, bool auto_advance = true) override;

private:
  Real ReadFile(FileName file_name);
  std::vector<Executioner *> _executioners;
  FileName _times_file;
  Real _porosity_change;
  Real _porosity_change_old;
};

#endif // REDBACKFULLSOLVEMULTIAPP_H
