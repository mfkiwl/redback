# Testing that gravity changes the stress (with depth for example) in the stress divergence kernel
# Based on oedometer settings (http://ascelibrary.org/doi/pdf/10.1061/40785%28164%2924)
# and taking into account pore pressure.
#
# The system is solved analytically as follows: (NOTE: need to amend those formulae!!! Expected num. values are correct though!)
# sigma'_zz + p_f = rho*g*L
# p_f = - Pe/(beta*(1-phi)) sigma'zz / (K+4G/3)
# sigma'_xx = sigma'_yy = K0*sigma'_zz
#
# This gives the solutions:
# p_f = - Pe / (beta(1-phi)k' - Pe) * rho*g*L
# with k' = (K+4G/3)
#
# Input:
# L = 1
# rho = 1
# g = -9.81
# E = 5e4
# nu = 0.2
#
# expected output at the location of the postprocessor, which is at the center of the bottom cell (95% down the way):
# K0 = E*nu/(E*(1-nu)) = 0.25
# p_f = +0.00176612
# sigma_zz  = -9.31773388
# sigma_xx = -2.32943347

[Mesh]
  type = GeneratedMesh
  dim = 3
  nz = 10
  xmin = -0.5
  xmax = 0.5
  ymin = -0.5
  ymax = 0.5
[]

[Variables]
  active = 'pore_pressure disp_z disp_y disp_x'
  [./disp_x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./disp_y]
    order = FIRST
    family = LAGRANGE
  [../]
  [./disp_z]
    order = FIRST
    family = LAGRANGE
  [../]
  [./temp]
  [../]
  [./pore_pressure]
  [../]
[]

[Materials]
  [./mat_mech]
    type = RedbackMechMaterialElastic
    block = 0
    disp_x = disp_x
    disp_y = disp_y
    exponent = 0
    youngs_modulus = 5e4
    poisson_ratio = 0.2
    ref_pe_rate = 0
    yield_stress = '0. 1 1. 1'
    total_porosity = 0.1
    disp_z = disp_z
    pore_pres = pore_pressure
  [../]
  [./mat_nomech]
    type = RedbackMaterial
    block = 0
    disp_x = disp_x
    disp_y = disp_y
    Aphi = 0
    ar = 0
    ar_F = 0
    ar_R = 0
    eta1 = 0
    gr = 0 # exp(-Ar), Ar=10
    phi0 = 0.1
    ref_lewis_nb = 1
    total_porosity = 0.1
    disp_z = disp_z
    confining_pressure = 0
    delta = 0
    is_mechanics_on = true
    eta2 = 0
    solid_compressibility = 1.1111111111 # 1/(0.9*0.3)
    gravity = '0 0 -9.81'
    solid_density = 1
    Peclet_number = 10
    pore_pres = pore_pressure
  [../]
[]

[BCs]
  active = 'confinex confiney basefixed_z'
  [./confinex]
    type = DirichletBC
    variable = disp_x
    boundary = 'left right'
    value = 0
  [../]
  [./confiney]
    type = DirichletBC
    variable = disp_y
    value = 0
    boundary = 'bottom top'
  [../]
  [./top_velocity]
    type = FunctionDirichletBC
    variable = disp_z
    function = 0
    boundary = front
  [../]
  [./basefixed_z]
    type = DirichletBC
    variable = disp_z
    boundary = back
    value = 0
  [../]
  [./basefixed_x]
    type = DirichletBC
    variable = disp_x
    boundary = back
    value = 0
  [../]
  [./basefixed_y]
    type = DirichletBC
    variable = disp_y
    boundary = back
    value = 0
  [../]
[]

[AuxVariables]
  active = 'stress_yy stress_xz stress_xx stress_xy stress_zz stress_yz'
  [./total_porosity]
    order = FIRST
    family = MONOMIAL
  [../]
  [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]

[Kernels]
  active = 'td_press poromech'
  [./td_temp]
    type = TimeDerivative
    variable = temp
  [../]
  [./temp_diff]
    type = Diffusion
    variable = temp
  [../]
  [./temp_dissip]
    type = RedbackMechDissip
    variable = temp
  [../]
  [./temp_endo_chem]
    type = RedbackChemEndo
    variable = temp
  [../]
  [./td_press]
    type = TimeDerivative
    variable = pore_pressure
  [../]
  [./press_diff]
    type = RedbackMassDiffusion
    variable = pore_pressure
  [../]
  [./chem_press]
    type = RedbackChemPressure
    variable = pore_pressure
    block = 0
  [../]
  [./thermal_pressurization]
    type = RedbackThermalPressurization
    variable = pore_pressure
    temperature = temp
  [../]
  [./poromech]
    type = RedbackPoromechanics
    variable = pore_pressure
  [../]
[]

[AuxKernels]
  active = 'stress_yy stress_xz stress_xx stress_xy stress_zz stress_yz'
  [./total_porosity]
    type = RedbackTotalPorosityAux
    variable = total_porosity
    mechanical_porosity = mech_porosity
  [../]
  [./stress_xx]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xx
    index_i = 0
    index_j = 0
  [../]
  [./stress_xy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xy
    index_i = 0
    index_j = 1
  [../]
  [./stress_xz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_xz
    index_i = 0
    index_j = 2
  [../]
  [./stress_yy]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yy
    index_i = 1
    index_j = 1
  [../]
  [./stress_yz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_yz
    index_i = 1
    index_j = 2
  [../]
  [./stress_zz]
    type = RankTwoAux
    rank_two_tensor = stress
    variable = stress_zz
    index_i = 2
    index_j = 2
  [../]
[]

[Postprocessors]
  [./p0]
    type = PointValue
    point = '0 0 0'
    variable = pore_pressure
  [../]
  [./zdisp]
    type = PointValue
    point = '0 0 0.5'
    variable = disp_z
  [../]
  [./stress_xx]
    type = PointValue
    point = '0 0 0'
    variable = stress_xx
  [../]
  [./stress_yy]
    type = PointValue
    point = '0 0 0'
    variable = stress_yy
  [../]
  [./stress_zz]
    type = PointValue
    point = '0 0 0'
    variable = stress_zz
  [../]
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
    petsc_options_iname = '-ksp_type -pc_type -snes_atol -snes_rtol -snes_max_it'
    petsc_options_value = 'bcgs bjacobi 1E-14 1E-10 10000'
  [../]
[]

[Executioner]
  type = Transient
  solve_type = Newton
  end_time = 10
  nl_abs_tol = 1e-10
  nl_rel_step_tol = 1e-10
  nl_abs_step_tol = 1e-10
[]

[Outputs]
  exodus = true
  execute_on = 'timestep_end initial'
  file_base = gravity_poro_stress
  csv = true
[]

[RedbackMechAction]
  [./solid]
    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z
    pore_pres = pore_pressure
  [../]
[]

