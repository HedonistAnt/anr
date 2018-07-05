function [voice, silence, below_thr, above_thr] = VAD_MFCC0(enval, fps, reset)
%VAD_MFCC0 Evaluates voice activity based on MFCC0 corresponding to
%weighted power envelope of the signal
%   c0 - MFCC0 coefficient form the front-end in range 0..1 fps - frames
%   per second voice - number of voice frames, voice if > 0 quite - number
%   of quite frames, quite if > 0

global count; %traced segment frame count
global sil_count; %bellow threshold frame count
global voice_count; %voice frame count
global b0; % stationary background nose level
global b1; % dynamic background noise level
global s0; % speech level

SPEECH_HANG = 1 * fps; % typical utterance length (1 sec)
SPEECH_ABORT = 3 * fps; % max utterance length (3 sec)
SNL_RATE = 6 / 256 / fps; % stationary noise threshold adaptation rate per sec
SNL_RATE_ABORT = 15 / 256 / fps; % stationary noise adaptation rate per sec to 
% recover from false voice
DNL_RATE = 10 / fps; % dynamic noise delta threshold adaptation rate per sec
SPEECH_RATE = 6 / 256 / fps; % speech level adaptation rate per sec
DYNAMIC_RANGE = 70 / 256; % typical dynamic range of the voice signal
SILENCE_THRESHOLD = 7/ 256; % silence detection level above the noise
VOICE_THRESHOLD = 14 / 256; % voice detection lelel above the noise
VOICE_DURATION = 0.06 * fps; % length of continous voice to be detectedin sec
SILENCE_DURATION = 0.2 * fps; % length of continous silence to be detected in sec

%Initial state
if reset
    count = -1;
    sil_count = 0;
    voice_count = 0;
    s0 = enval;
    b1 = enval;
    b0 = enval;
end

count = count + 1;

%adapt stationary noise level
if enval < b0
    b0 = enval;
    count = 0;
elseif count > SPEECH_ABORT
    b0 = b0 + SNL_RATE_ABORT;
elseif count > SPEECH_HANG
    b0 = b0 + SNL_RATE;
end

%adapt dynamic noise level
if enval < b0 + SILENCE_THRESHOLD
    b1 = b1 + DNL_RATE * (enval - b1);
end

%adapt speech level
if s0 < enval
    s0 = enval;
else
    s0 = s0 - SPEECH_RATE;
end

%expected noise level is dynamic noise level plus 25% of expected speech
%level excess over the staionary noise
expected = b1 + max(0, s0 - b0 - DYNAMIC_RANGE) / 4;

if enval > expected + VOICE_THRESHOLD
    voice_count = voice_count + 1;
else
    voice_count = 0;
end

if enval < expected + SILENCE_THRESHOLD
    sil_count = sil_count + 1;
else
    sil_count = 0;
end

if voice_count > VOICE_DURATION
    voice = voice_count;
else
    voice = 0;
end

if sil_count > SILENCE_DURATION
    silence = sil_count;
else
    silence = 0;
end
below_thr = sil_count;
above_thr = voice_count;
end

