
import 'package:challengeapp/common/model/attached_entity.dart';
import 'package:challengeapp/credit/service/credit_service.dart';
import 'package:challengeapp/reward/dao/bought_reward_dao.dart';
import 'package:challengeapp/reward/dao/reward_dao.dart';
import 'package:challengeapp/reward/model/bought_reward_model.dart';
import 'package:challengeapp/reward/model/reward_model.dart';

class RewardService {
  final RewardDao _rewardDao;
  final BoughtRewardDao _boughtRewardDao;
  final CreditService _creditService;

  final Map<int, Future<BoughtReward>> _cache = new Map();

  RewardService(this._rewardDao, this._boughtRewardDao, this._creditService);

  AttachedEntity<Reward> attach(Reward r) {
    return _rewardDao.attach(r);
  }

  Future<Reward> save(Reward reward) {
    return _rewardDao.save(reward);
  }

  Future<List<Reward>> listRewards(int limit, int offset) {
    return _rewardDao.list(limit, offset);
  }

  Future<List<BoughtReward>> listBoughtRewards() {
    return _boughtRewardDao.list(999, 0);
  }

  Future<int> deleteReward(Reward reward) {
    _cache.remove(reward.id);
    return _rewardDao.delete(reward.id);
  }

  Future<BoughtReward> buyReward(Reward reward) async {
    var boughtReward = BoughtReward.fromReward(reward);
    boughtReward.boughtAt = DateTime.now();
    boughtReward = await _boughtRewardDao.save(boughtReward);
    _creditService.spendCredits(boughtReward.cost);
    _cache[reward.id] = Future.value(boughtReward);
    return boughtReward;
  }

  Future<BoughtReward> getLastBoughtRewardByRewardId(int rewardId) {
    Future<BoughtReward> result = _cache[rewardId];
    if (result == null) {
      result = _boughtRewardDao.getMostRecentByRewardId(rewardId);
      _cache[rewardId] = result;
    }
    return result;
  }

  Future<int> countBoughtRewards() {
    return this._boughtRewardDao.countAll();
  }
}