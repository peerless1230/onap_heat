(where (and (service #"{{service}}")
            (not (expired? event)))
  (let [downstream (autohealing/downstream* index check-restraints-and-process)]
    (ewma-timeless {{ewma_timeless_r}}
      (where ((threshold-computing/inequality "{{upper_bound}}") metric {{threshold}})
        (with {:state EVENT-TRIGGERING-STATE
               :diagnose "{{constants.EWMA_FAILURE}}"}
              downstream)
        (else
          (with :state EVENT-STABLE-STATE downstream))))))
