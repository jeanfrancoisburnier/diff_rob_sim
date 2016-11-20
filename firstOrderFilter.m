function filtered = firstOrderFilter(last_val, new_val, tau, delta_t)
    f = delta_t / tau;
	frac = 1.0 / (1.0 + f);

	filtered = f * frac * new_val + frac * last_val;
end