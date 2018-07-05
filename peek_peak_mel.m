%
% Derived from Nuance SREC under APL license
%
% Performs perceptual frequency masking

function density = peek_peak_mel(params, density)
    
    bdecay_all = [0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.699999988000000,0.705243053909410,0.711796886296171,0.718350718682933,0.724633729557194,0.730220342256454,0.735806954955714,0.741393567654973,0.746638337161341,0.751387098897629,0.756135860633918,0.760884622370207,0.765525875780964,0.769552135329535,0.773578394878105,0.777604654426676,0.781630913975247,0.785369458825201,0.788775215659362,0.792180972493524,0.795586729327685,0.798992486161847,0.802233621081855,0.805108421695839,0.807983222309822,0.810858022923806,0.813732823537790,0.816607624151774,0.819192131758104,0.821614094465985,0.824036057173866,0.826458019881747,0.828879982589628,0.831301945297509,0.833567894698818,0.835604789665800,0.837641684632782,0.839678579599765,0.841715474566747,0.843752369533729,0.845789264500712,0.847647962148038,0.849358293349420,0.851068624550801,0.852778955752182,0.854489286953563,0.856199618154945,0.857909949356326,0.859620213897929,0.861054265827360,0.862488317756792,0.863922369686224,0.865356421615655,0.866790473545087,0.868224525474518,0.869658577403950,0.871092629333382,0.872363360267754,0.873564184917909,0.874765009568064,0.875965834218218,0.877166658868373,0.878367483518527,0.879568308168682,0.880769132818837,0.881969957468991,0.883058722452755,0.884063051838707,0.885067381224659,0.886071710610611,0.887076039996563,0.888080369382515,0.889084698768467,0.890089028154419,0.891093357540371,0.892097686926323,0.893014875117074,0.893853951891882,0.894693028666690,0.895532105441498,0.896371182216305,0.897210258991113,0.898049335765921,0.898888412540729,0.899727489315537,0.900566566090344,0.901405642865152,0.902178110911607,0.902878434896206,0.903578758880804,0.904279082865403,0.904979406850002,0.905679730834600,0.906380054819199,0.907080378803798,0.907780702788397,0.908481026772995,0.909181350757594,0.909881674742193,0.910543835063838,0.911127827193604,0.911711819323371,0.912295811453138,0.912879803582905,0.913463795712671,0.914047787842438,0.914631779972205,0.915215772101971,0.915799764231738,0.916383756361505,0.916967748491272,0.917551740621038,0.918135732750805,0.918626132366125,0.919112720001684,0.919599307637242,0.920085895272801,0.920572482908360,0.921059070543918,0.921545658179477,0.922032245815036,0.922518833450594,0.923005421086153,0.923492008721712,0.923978596357270,0.924465183992829,0.924951771628388,0.925417428410940,0.925822557469718,0.926227686528496,0.926632815587273,0.927037944646051,0.927443073704829,0.927848202763606,0.928253331822384,0.928658460881162,0.929063589939939,0.929468718998717,0.929873848057495,0.930278977116272,0.930684106175050,0.931089235233828,0.931494364292606];
    fdecay_all = [0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.300000012000000,0.307886371077605,0.317744319924611,0.327602268771616,0.337232176633107,0.346275693388989,0.355319210144872,0.364362726900754,0.373069460898832,0.381287529718921,0.389505598539010,0.397723667359099,0.405820580633941,0.413224432080059,0.420628283526177,0.428032134972295,0.435435986418413,0.442475555421436,0.449093773579305,0.455711991737174,0.462330209895043,0.468948428052912,0.475335882371764,0.481209816292943,0.487083750214122,0.492957684135302,0.498831618056481,0.504705551977660,0.510134430917443,0.515314108481897,0.520493786046351,0.525673463610806,0.530853141175260,0.536032818739714,0.540953587655485,0.545494234033190,0.550034880410895,0.554575526788599,0.559116173166304,0.563656819544009,0.568197465921714,0.572420826637832,0.576380016455925,0.580339206274018,0.584298396092111,0.588257585910204,0.592216775728297,0.596175965546390,0.600135028991219,0.603570449994095,0.607005870996971,0.610441291999847,0.613876713002723,0.617312134005599,0.620747555008475,0.624182976011351,0.627618397014227,0.630726340584068,0.633694113990846,0.636661887397624,0.639629660804402,0.642597434211180,0.645565207617958,0.648532981024736,0.651500754431515,0.654468527838293,0.657200035968775,0.659753521082694,0.662307006196613,0.664860491310533,0.667413976424452,0.669967461538371,0.672520946652290,0.675074431766209,0.677627916880128,0.680181401994047,0.682542688549191,0.684731692620333,0.686920696691476,0.689109700762618,0.691298704833760,0.693487708904902,0.695676712976044,0.697865717047186,0.700054721118328,0.702243725189470,0.704432729260612,0.706468745823560,0.708339061276050,0.710209376728540,0.712079692181029,0.713950007633519,0.715820323086009,0.717690638538498,0.719560953990988,0.721431269443478,0.723301584895967,0.725171900348457,0.727042215800947,0.728821620193133,0.730414817270411,0.732008014347689,0.733601211424967,0.735194408502245,0.736787605579523,0.738380802656801,0.739973999734079,0.741567196811357,0.743160393888635,0.744753590965913,0.746346788043191,0.747939985120469,0.749533182197748,0.750895977818179,0.752249389293995,0.753602800769811,0.754956212245627,0.756309623721443,0.757663035197259,0.759016446673074,0.760369858148890,0.761723269624706,0.763076681100522,0.764430092576338,0.765783504052154,0.767136915527969,0.768490327003785,0.769790660854156,0.770937505123825,0.772084349393494,0.773231193663163,0.774378037932832,0.775524882202501,0.776671726472170,0.777818570741839,0.778965415011508,0.780112259281177,0.781259103550846,0.782405947820515,0.783552792090184,0.784699636359853,0.785846480629522,0.786993324899191];

    first = params.cut_off_below;
    last = params.cut_off_above;
    
    if last > length(density)
        last = length(density);
    end

    peak = density(last);
    for  i = last:-1:first
        peak = peak * bdecay_all(i - first + 1);
        if density(i) > peak
            peak = density(i);
        else
            density(i) = peak;
        end
    end

    peak = density(first);
    for i = first:last
        peak = peak * fdecay_all(i - first + 1);
        if density(i) > peak
            peak = density(i);
        else
            density(i) = peak;
        end
    end
end