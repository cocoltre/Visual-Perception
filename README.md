# VISUAL-PERCEPTION

This project analyzes visual perception using Hidden Markov Models (HMMs) and Generalized Linear Models (GLMs). It includes predictive templates, HMM parameter estimation, and outcome modeling for different participant groups.

## Directory Structure

```
VISUAL-PERCEPTION/
├── Data/       # All data for visual_perception
│   ├── 001     # 1st participant data
│   ├── ...
│
├── Full_Data/                                      # Full data ready to be used
│   ├── Full_Data_predictive_templates.csv          # Full data for predicive_templates
│   ├── Full_Data_visual_perception.csv             # Full data for visual_perception
│   └── test_model_intervals_64.csv                 # Full data for testing model (in visual_perception)
│
├── HMM/                                            # All HMM-related results
│   ├── HMM_predictive_templates/                   # Experiments for predicive_templates
│   │   ├── 5participants/                          # Experiment with 5 participants
│   │   │   ├── BIC_across_models.csv               # BIC when 1 and 2 states
│   │   │   ├── BIC_permuted_across_models.csv      # BIC with permuted data when 1 and 2 states
│   │   │   ├── Full_HMM_5participants.csv          # Final HMM results
│   │   │   ├── Full_model_outcome_states_1.csv     # BIC + parameters when 1 state
│   │   │   ├── Full_model_outcome_states_2.csv     # BIC + parameters when 2 states
│   │   │   ├── one_level_HMM_params.csv            # Parameters for each variable for n_iter iterations
│   │   │   └── two_state_init_param.csv            # Parameters for each variable + transition probabilities for n_iter iterations
│   │   ├── 5participants-withbias/                 # Experiment with 5 participants, with bias
│   │   ├── 6participants/                          # Experiment with 6 participants
│   │   ├── 6participants-withbias/                 # Experiment with 6 participants, with bias
│   │   ├── adj-sym/                                # Experiment when adjusting inputs according to symmetry
│   │   ├── contrast/                               # Experiment with contrast as external variable, by default
│   │   ├── normalized/                             # Experiment when normalizing inputs
│   │   └── withbias/                               # Experiment with bias
│   └── HMM_visual_perception/                      # Experiments for visual_perception
│       ├── simulation1/                            # Simulation1
│       ├── simulation1-1part/                      # Simulation1 with whole data as 1 participant/ID
│       ├── ...
│
├── plots/                                          # All plots
│   ├── plots_predictive_templates/                 # Plots for predictive_templates
│   │   ├── 5participants/
│   │   │   ├── BIC_across_models.png
│   │   │   ├── BIC_comparison.png
│   │   │   ├── congruency_alltrials.png
│   │   │   ├── ...
│   │   ├── 5participants-withbias/
│   │   ├── 6participants/
│   │   ├── 6participants-withbias/
│   │   ├── contrast/
│   │   ├── normalized/
│   │   ├── normalized-sym/
│   │   └── withbias/
│   └── plots_visual_perception/                    # Plots for visual_perception
│       ├── simulation1/
│       ├── simulation1-1part/
│       ├── ...
├── simulations/                                    # Simulations data
│   ├── simulated_forced_choice1.csv                # Data for simulation1
│   ├── simulated_forced_choice2.csv                # Data for simulation2
│   ├── ...
├── ssm/                                            # ssm package if difficulties in downloading ssm
│
├── GLM_HMM_predictive_templates.ipynb              # Notebook for experiments in predictive_templates
├── GLM_HMM_visual_perception.ipynb                 # Notebook for experiments in visual_perception
└── README.md                                       # This file
```

## Main variables
These 3 variables are the ones you always need to verify when running an experiment:  
- `save_data`, bool: Saves data (HMM-related results and plots), or not.  
- `test_type`, str: Name of the experiment.  
- `want_another_test`, bool: For predictive_templates: Only for test_type = '?participants...'. Redoes a simulation/test that chooses randomly ?participants, or not. For visual_perception: Only for test_type = 'test_model'. Redoes a simulation/test that chooses randomly a NOT noisy simulation, or not.  

These following variables need to be verified when running a new experiment:  
- `bias`, bool: Adds a bias parameter, or not.  
- `test_type_title`, str: Title of the experiment, used in plots.  
- `prev_var`, str: Internal variable, related to something happened previously.  
- `prev_var_title`, str: Title for the internal variable.  
- `ext_var`, str: External variable, related to something happening externally.  
- `ext_var_title`, str: Title for the external variable.  
- (In `## Check that the model is working` section) `n`, int: Number of trials for creating a NOT noisy simulation.  
- (In `## Check that the model is working` section) `orientation_perc_external`, float: Probability of simulated responses following orientation in external state.  
- (In `## Check that the model is working` section) `orientation_perc_internal`, float: Probability of simulated responses following orientation in internal state.  
- (In `## Load and prepare inputs` section) `n`, int: Number of participants (= 6 by default).  
- `selected_id`, int: Participant Id for plotting (= 1, from 1 to 6 by default).  
- `selected_block`, int: Block index for plotting (= 1, from 1 to 10 by default).  
- `window_size`, int: Window size of mode calculation (= 5 by default).  
- `obs_dim`, int: Dimension of the output (= 1 by default).  
- `num_categories`, int: Number of categories for output (= 2 by default).  
- `input_dim`, int: Dimension of the input (= 2 or 3).  
-  `N_iters`, int: Number of EM iterations per fit (= 500 by default).  
- `num_states`, int: Number of predicted states (= 1 or 2).  
- `n_iter`, int: Number of model restarts (= 100 by default).  
- `transition_alpha`, int: Hyperparameter to control the probabilities of moving from one hidden state to another (= 1 by default).  
- `prior_sigma`, float: Standard deviation of Gaussian prior on GLM weights (= 10 by default).  
- `max_num_states`, int: Maximum number of predicted states (= 2 by default).  
- `n_perm`, int: Number of permutations (= 100 by default).  
- `sess_id`, int: Session ID (same as `selected_id` - 1: = 0, from 0 to 5 by default).  

## Getting Started

To run an experiment:
1. Go to the corresponding notebook to generate analysis and figures:  
- GLM_HMM_predictive_templates  
- GLM_HMM_visual_perception  
2. In second cell, choose these variables according to your experiment:
```
save_data = True
test_type = 'normalized-sym'     
want_another_test = False  
```
3. If new experiment, change the notebook according to it. For example, if your new experiment consists in only reducing data, add the experiment in the `Setup`section, then modify the `## Load and prepare inputs` section.  
4. If already-existing experiment, choose an experiment between:  
- For predictive_templates:  
    - 5 participants  
    - 5 participants-withbias  
    - 6 participants  
    - 6 participants-withbias  
    - adj-sym  
    - contrast  
    - normalized  
    - withbias  
- For visual_perception:  
    - simulation1  
    - simulation1-1part  
    - simulation1-2blocks  
    - simulation1-withoutbias  
    - simulation2  
    - simulation2-1part  
    - simulation2-withoutbias  
    - simulation3  
    - simulation4  
    - simulation5  
    - simulation5-adj 
    - simulation5-norm  
    - simulation5-norm-withoutbias  
    - simulation5-sym  
    - simulation5-withoutbias  
    - test_model  
    - with006  
    - without0ms  
    - without006  
    - without60ms  
    - without300ms  
    - withoutbias   
5. Run the whole notebook.

## Notes

- HMMs are used to identify latent states in participants' visual responses.
- GLMs help quantify the relationship between stimuli and participant responses.
- Model performance is compared using BIC and permutation testing.
