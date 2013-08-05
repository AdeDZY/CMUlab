function [data]=StandardAmplitude(data)
    m = max(abs(data));
    data = data / m;
end